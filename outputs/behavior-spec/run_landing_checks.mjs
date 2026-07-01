import { chromium } from "playwright";

const base = "http://127.0.0.1:8765";
const results = [];

function record(id, ok, detail) {
  results.push({ id, ok, detail });
  console.log(`${ok ? "PASS" : "FAIL"} ${id}: ${detail}`);
}

const browser = await chromium.launch({ headless: true });
try {
  const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
  await page.goto(`${base}/landing%20page/index.html`, { waitUntil: "networkidle" });

  record("SITE-001", await page.locator('.site-nav a[href="#tour"]').count() === 1 && await page.locator('.site-nav a[href="#review"]').count() === 1 && await page.locator('.site-nav a[href="#cli"]').count() === 1 && await page.locator('.site-nav a[href="#waitlist"]').count() === 1, "primary nav anchors are present");
  record("SITE-006", await page.locator(".packet-board").isVisible() && await page.getByRole("button", { name: "Accept hunk" }).isVisible(), "review packet preview and static action buttons render");
  record("SITE-007", (await page.locator(".hero__proof").innerText()).includes(".pagepacket/"), "hero product facts render .pagepacket sidecar copy");
  record("SITE-008", await page.locator("#tour").isVisible(), "tour section is present");
  record("SITE-009", await page.locator("#review .flow-row").count() === 4, "packet contents section has four rows");
  record("SITE-010", (await page.locator("#cli").innerText()).includes("pagepacket-cli status"), "static CLI marketing block renders pagepacket-cli example");
  record("SITE-011", await page.locator(".reveal").first().evaluate((el) => getComputedStyle(el).opacity === "1"), "reveal targets are visible by default");
  record("SITE-014", await page.locator("footer a[href=\"#waitlist\"]").count() === 1, "footer waitlist link is present");

  await page.locator("#hero-email").fill("not-an-email");
  await page.locator('form[data-waitlist-form]').first().getByRole("button", { name: "Join waitlist" }).click();
  record("SITE-004-error", await page.locator('form[data-waitlist-form]').first().getAttribute("data-state") === "error", "invalid hero email sets error state");

  await page.locator("#hero-email").fill("codex@example.com");
  await page.locator('form[data-waitlist-form]').first().getByRole("button", { name: "Join waitlist" }).click();
  const saved = await page.evaluate(() => JSON.parse(localStorage.getItem("pagepacket-waitlist-preview") || "[]"));
  record("SITE-002/SITE-005", saved.includes("codex@example.com") && await page.locator('form[data-waitlist-form]').first().getAttribute("data-state") === "success", "valid hero waitlist submission stores deduped local preview email");

  await page.locator("#footer-email").fill("footer@example.com");
  await page.locator("#waitlist").locator("form").getByRole("button", { name: "Request access" }).click();
  const savedFooter = await page.evaluate(() => JSON.parse(localStorage.getItem("pagepacket-waitlist-preview") || "[]"));
  record("SITE-003", savedFooter.includes("footer@example.com"), "footer waitlist form stores local preview email");

  await page.evaluate(() => {
    const form = document.querySelector("[data-waitlist-form]");
    form.setAttribute("action", "/api/waitlist");
    window.__fetchPayload = null;
    window.fetch = async (url, options) => {
      window.__fetchPayload = { url, options };
      return { ok: true };
    };
  });
  await page.locator("#hero-email").fill("api@example.com");
  await page.locator('form[data-waitlist-form]').first().getByRole("button", { name: "Join waitlist" }).click();
  const fetchPayload = await page.evaluate(() => window.__fetchPayload);
  record("SITE-012", fetchPayload?.url === "/api/waitlist" && fetchPayload?.options?.method?.toLowerCase() === "post" && fetchPayload?.options?.body?.includes("api@example.com"), "custom endpoint branch posts JSON to non-/waitlist action");

  const mobile = await browser.newPage({ viewport: { width: 375, height: 900 } });
  await mobile.goto(`${base}/landing%20page/index.html`, { waitUntil: "networkidle" });
  record("SITE-013", await mobile.locator(".waitlist-form").first().boundingBox().then((box) => box && box.width <= 360), "mobile viewport keeps waitlist form within viewport width");
  await mobile.close();

  const alt = await browser.newPage({ viewport: { width: 1200, height: 900 } });
  await alt.goto(`${base}/landing%20page/index%202.html`, { waitUntil: "networkidle" });
  const altLinks = await alt.evaluate(() => Array.from(document.querySelectorAll("link[rel='stylesheet']")).map((el) => el.getAttribute("href")));
  const altScripts = await alt.evaluate(() => Array.from(document.querySelectorAll("script[src]")).map((el) => el.getAttribute("src")));
  record("SITE-015/SITE-016/SITE-017", altLinks.includes("styles%202.css") && !altLinks.includes("styles.css") && altScripts.includes("script%202.js") && !altScripts.includes("script.js"), "alternate page loads companion CSS/JS assets");
  await alt.close();

  const failed = results.filter((r) => !r.ok);
  if (failed.length) process.exitCode = 1;
} finally {
  await browser.close();
}
