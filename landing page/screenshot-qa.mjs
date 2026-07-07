import { chromium } from "playwright";
import { mkdirSync } from "node:fs";

const BASE = "http://localhost:4173/";
const OUT = "./qa/terminal-meets-paper";
mkdirSync(OUT, { recursive: true });

const viewports = [
  { w: 1440, h: 900, label: "desktop" },
  { w: 768, h: 1024, label: "tablet" },
  { w: 414, h: 896, label: "mobile-414" },
  { w: 375, h: 812, label: "mobile-375" },
  { w: 320, h: 568, label: "mobile-320" },
];

const browser = await chromium.launch();

for (const v of viewports) {
  const context = await browser.newContext({
    viewport: { width: v.w, height: v.h },
    deviceScaleFactor: 1,
  });
  const page = await context.newPage();

  const messages = [];
  page.on("console", (m) => messages.push(`[${m.type()}] ${m.text()}`));
  page.on("pageerror", (e) => messages.push(`[pageerror] ${e.message}`));

  await page.goto(BASE, { waitUntil: "networkidle" });
  // Let fonts + scroll-triggers settle
  await page.waitForTimeout(1500);

  // Full-page screenshot
  await page.screenshot({
    path: `${OUT}/full-${v.label}.png`,
    fullPage: true,
  });

  // Above-the-fold hero only
  await page.screenshot({
    path: `${OUT}/hero-${v.label}.png`,
    fullPage: false,
  });

  // Horizontal-scroll check
  const hScroll = await page.evaluate(() => ({
    scrollWidth: document.documentElement.scrollWidth,
    clientWidth: document.documentElement.clientWidth,
    bodyScroll: document.body.scrollWidth,
  }));
  const overflows = hScroll.scrollWidth > hScroll.clientWidth + 1
    || hScroll.bodyScroll > hScroll.clientWidth + 1;

  // Clickable-text-wrap check: scan buttons, nav links, CTA labels
  const wrappedClickables = await page.evaluate(() => {
    const sel = "button, .nav-term a, .term-flag, .form-submit, a[href]";
    const problems = [];
    document.querySelectorAll(sel).forEach((el) => {
      const rect = el.getBoundingClientRect();
      // crude wrap detection: line-height vs height for a single-line affordance
      const style = getComputedStyle(el);
      const lh = parseFloat(style.lineHeight) || 18;
      if (rect.height > lh * 1.9 && rect.width < 280) {
        problems.push({
          text: (el.textContent || "").trim().slice(0, 40),
          h: Math.round(rect.height),
          w: Math.round(rect.width),
        });
      }
    });
    return problems;
  });

  console.log(
    `[${v.label} ${v.w}x${v.h}] overflow=${overflows ? "YES" : "no"} ` +
    `clickableWraps=${wrappedClickables.length} ` +
    `consoleErrors=${messages.filter((m) => m.includes("pageerror")).length}`
  );
  if (wrappedClickables.length) {
    console.log("  wrapped:", JSON.stringify(wrappedClickables.slice(0, 4)));
  }
  if (messages.some((m) => m.includes("pageerror"))) {
    console.log("  errors:", messages.filter((m) => m.includes("pageerror")).slice(0, 3));
  }

  await context.close();
}

await browser.close();
console.log("QA complete — screenshots in", OUT);
