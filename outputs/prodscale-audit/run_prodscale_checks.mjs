import fs from "node:fs/promises";
import path from "node:path";
import { execFile as execFileCallback } from "node:child_process";
import { createRequire } from "node:module";
import { promisify } from "node:util";

const execFile = promisify(execFileCallback);
const repoRoot = path.resolve(import.meta.dirname, "../..");
const require = createRequire(import.meta.url);
const { chromium } = require(path.join(repoRoot, "outputs/behavior-spec/node_modules/playwright"));
const baseURL = process.env.PAGEPACKET_LANDING_BASE_URL || "http://127.0.0.1:8766";
const cliPath = process.env.PAGEPACKET_CLI || "/tmp/pagepacket-prodscale-build/debug/pagepacket-cli";
const fixtureRoot = path.join(repoRoot, "outputs/prodscale-fixtures/pagepacket-prodscale-vault");
const fixtureGenerator = path.join(repoRoot, "outputs/prodscale-fixtures/generate_prodscale_fixture.mjs");

const results = [];

function record(id, ok, detail) {
  results.push({ id, ok, detail });
  console.log(`${ok ? "PASS" : "FAIL"} ${id}: ${detail}`);
}

async function exists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function runCLI(args) {
  try {
    const { stdout, stderr } = await execFile(cliPath, args, { cwd: repoRoot });
    return { code: 0, stdout, stderr };
  } catch (error) {
    return {
      code: error.code ?? 1,
      stdout: error.stdout ?? "",
      stderr: error.stderr ?? "",
    };
  }
}

await execFile("node", [fixtureGenerator], { cwd: repoRoot });

const status = await runCLI(["status", fixtureRoot]);
record("CLI-PROD-001", status.code === 0 && status.stdout.includes("Markdown files: 366"), "status reports 366 visible Markdown files");
record("CLI-PROD-002", !status.stdout.includes(".pagepacket") || status.stdout.includes("Sidecar:"), "status output does not list hidden sidecar Markdown files as documents");

const outsidePath = path.join(repoRoot, "outputs/prodscale-fixtures/outside-vault-file.md");
await fs.writeFile(outsidePath, "# Outside vault fixture\n", "utf8");
const traversal = await runCLI(["snapshot", fixtureRoot, "../outside-vault-file.md", "--message", "Traversal should fail"]);
record(
  "CLI-PROD-003",
  traversal.code !== 0 && /outside the vault|outside vault|refusing/i.test(`${traversal.stdout}\n${traversal.stderr}`),
  "snapshot refuses to read a file outside the selected vault"
);

const browser = await chromium.launch({ headless: true });
try {
  const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
  await page.goto(baseURL, { waitUntil: "networkidle" });

  const faviconHref = await page.locator('link[rel="icon"]').getAttribute("href");
  const faviconResponse = faviconHref
    ? await page.request.get(new URL(faviconHref, page.url()).toString())
    : null;
  record("WEB-PROD-001", Boolean(faviconResponse?.ok()), `favicon resolves through the served app: ${faviconHref}`);

  const pageText = await page.locator("body").innerText();
  record(
    "WEB-PROD-002",
    pageText.includes("pagepacket")
      && pageText.includes("pagepacket-cli")
      && pageText.includes(".pagepacket")
      && !/\bgraft\b/i.test(pageText),
    "landing visible copy uses Pagepacket, pagepacket-cli, and .pagepacket vocabulary"
  );

  const requiredSections = ["#top", "#agents", "#workflow", "#files", "#waitlist"];
  record(
    "WEB-PROD-003",
    await page.evaluate((selectors) => selectors.every((selector) => Boolean(document.querySelector(selector))), requiredSections),
    "landing app exposes all primary sections"
  );

  await page.evaluate(() => localStorage.setItem("pagepacket-waitlist-preview", "{not-json"));
  await page.locator("#hero-email").fill("recover@example.test");
  await page.locator("form").first().getByRole("button", { name: /save my spot/i }).click();
  await page.locator("form").first().getByRole("button", { name: /spot saved/i }).waitFor();
  const recoveredState = await page.locator(".form-row").first().getAttribute("data-status");
  const recoveredEmails = await page.evaluate(() => JSON.parse(localStorage.getItem("pagepacket-waitlist-preview") || "[]"));
  record(
    "WEB-PROD-004",
    recoveredState === "success" && recoveredEmails.includes("recover@example.test"),
    "waitlist form recovers from corrupted localStorage preview data"
  );

  const mobile = await browser.newPage({ viewport: { width: 375, height: 900 } });
  await mobile.goto(baseURL, { waitUntil: "networkidle" });
  const overflowWidth = await mobile.evaluate(() => document.documentElement.scrollWidth - document.documentElement.clientWidth);
  record("WEB-PROD-005", overflowWidth <= 1, "mobile landing page has no meaningful horizontal overflow");
  await mobile.close();
} finally {
  await browser.close();
}

const failures = results.filter((result) => !result.ok);
if (failures.length > 0) {
  process.exitCode = 1;
}
