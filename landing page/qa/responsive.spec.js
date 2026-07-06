import { test, expect } from "@playwright/test";

const pageUrl = "http://127.0.0.1:5173/";
const targetSize = 44;
const viewports = [
  { width: 320, height: 900 },
  { width: 375, height: 900 },
  { width: 414, height: 900 },
  { width: 768, height: 900 },
  { width: 1280, height: 800 },
];

async function openLanding(page, viewport, reducedMotion = "no-preference") {
  await page.setViewportSize(viewport);
  await page.emulateMedia({ reducedMotion });
  await page.goto(pageUrl, { waitUntil: "domcontentloaded" });
  await page.evaluate(() => document.fonts?.ready);
  await expect(page.locator(".graft-page")).toBeVisible();
}

async function expectNoHorizontalOverflow(page) {
  const metrics = await page.evaluate(() => {
    const root = document.documentElement;
    return {
      scrollWidth: root.scrollWidth,
      clientWidth: root.clientWidth,
    };
  });

  expect(metrics.scrollWidth).toBeLessThanOrEqual(metrics.clientWidth + 1);
}

test.describe("graft landing page", () => {
  for (const viewport of viewports) {
    test(`no overflow, wrapped affordances, or tiny targets at ${viewport.width}px`, async ({ page }) => {
      const errors = [];
      page.on("console", (message) => {
        if (message.type() === "error") errors.push(message.text());
      });

      await openLanding(page, viewport);

      const metrics = await page.evaluate(() => {
        const root = document.documentElement;
        const affordances = [...document.querySelectorAll("a, button")]
          .filter((node) => {
            const rect = node.getBoundingClientRect();
            const style = getComputedStyle(node);
            return rect.width > 0 && rect.height > 0 && style.visibility !== "hidden" && style.display !== "none";
          })
          .map((node) => {
            const rect = node.getBoundingClientRect();
            const style = getComputedStyle(node);
            return {
              label: node.getAttribute("aria-label") || node.textContent.trim() || node.getAttribute("href"),
              tagName: node.tagName.toLowerCase(),
              href: node.getAttribute("href"),
              width: rect.width,
              height: rect.height,
              lineHeight: parseFloat(style.lineHeight),
            };
          });

        return {
          scrollWidth: root.scrollWidth,
          clientWidth: root.clientWidth,
          affordances,
        };
      });

      expect(errors).toEqual([]);
      expect(metrics.scrollWidth).toBeLessThanOrEqual(metrics.clientWidth + 1);
      for (const item of metrics.affordances) {
        const label = `${item.tagName}${item.href ? ` ${item.href}` : ""} "${item.label}"`;
        expect(item.height).toBeLessThanOrEqual(Math.max(58, item.lineHeight * 1.8));
        expect(item.width, `${label} should be at least ${targetSize}px wide`).toBeGreaterThanOrEqual(targetSize);
        expect(item.height, `${label} should be at least ${targetSize}px tall`).toBeGreaterThanOrEqual(targetSize);
      }

      const heroSubmit = page.locator("#top form").first().getByRole("button");
      await expect(heroSubmit).toBeVisible();
      const heroSubmitBox = await heroSubmit.boundingBox();
      expect(heroSubmitBox).not.toBeNull();
      if (!heroSubmitBox) return;
      expect(heroSubmitBox.y + heroSubmitBox.height).toBeLessThanOrEqual(viewport.height);
    });
  }

  test("reduced motion keeps static page content readable", async ({ page }) => {
    await openLanding(page, { width: 375, height: 900 }, "reduce");
    await expect(page.getByRole("heading", { level: 1 })).toBeVisible();
    await expect(page.locator("#top form").first()).toBeVisible();
    await expect(page.getByLabel("graft navigation")).toBeVisible();
    await expectNoHorizontalOverflow(page);

    const hiddenReveals = await page.locator(".js-reveal").evaluateAll((nodes) =>
      nodes
        .filter((node) => {
          const rect = node.getBoundingClientRect();
          return rect.width > 0 && rect.height > 0;
        })
        .filter((node) => {
          const style = getComputedStyle(node);
          return Number(style.opacity) < 0.95 || style.visibility === "hidden";
        })
        .map((node) => node.textContent.trim().slice(0, 80)),
    );

    expect(hiddenReveals).toEqual([]);
  });

  test("waitlist form validates and reaches restored success state", async ({ page }) => {
    await openLanding(page, { width: 768, height: 900 });

    const waitlistForm = page.locator("#top form").first();
    const email = waitlistForm.getByRole("textbox");
    const submit = waitlistForm.getByRole("button");
    const helperId = await email.getAttribute("aria-describedby");
    expect(helperId).toBeTruthy();
    const helper = page.locator(`#${helperId}`);

    await email.fill("not-an-email");
    await submit.click();
    await expect(email).toHaveAttribute("aria-invalid", "true");
    await expect(helper).toContainText("that email needs an @ and a domain.");

    await email.fill("reader@example.com");
    await submit.click();
    await expect(submit).toHaveText("spot saved");
    await expect(helper).toContainText("i'll use this email when the first waitlist build is ready.");
  });
});
