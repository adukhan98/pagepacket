/**
 * Programmatic Visual QA for Graft Landing Page
 * Checks: contrast ratios, element positions, font loading, seam visibility, register colors
 */
import { chromium } from 'playwright';

const VIEWPORTS = [
  { name: 'desktop', w: 1440, h: 900 },
  { name: 'tablet', w: 768, h: 1024 },
  { name: 'mobile', w: 375, h: 812 },
];

async function qa() {
  const browser = await chromium.launch();
  const results = [];

  for (const vp of VIEWPORTS) {
    const context = await browser.newContext({ viewport: vp });
    const page = await context.newPage();
    const errors = [];
    const warnings = [];

    // Collect console errors
    page.on('console', msg => {
      if (msg.type() === 'error') errors.push(msg.text());
    });

    await page.goto('http://localhost:4173', { waitUntil: 'networkidle' });

    // 1. Check fonts loaded
    const fontCheck = await page.evaluate(() => {
      const fonts = performance.getEntriesByType('resource')
        .filter(r => r.initiatorType === 'css' || r.name.includes('fonts.googleapis.com') || r.name.includes('fonts.gstatic.com'));
      const usedFonts = document.fonts ? [...document.fonts].map(f => f.family) : [];
      return { googleFontRequests: fonts.length, loadedFonts: usedFonts };
    });
    
    // Check if our key fonts are available
    const hasFraunces = fontCheck.loadedFonts.some(f => f.includes('Fraunces'));
    const hasPlexSans = fontCheck.loadedFonts.some(f => f.includes('IBM Plex Sans'));
    const hasJetBrains = fontCheck.loadedFonts.some(f => f.includes('JetBrains Mono'));
    if (!hasFraunces) warnings.push('Fraunces font may not be loaded');
    if (!hasPlexSans) warnings.push('IBM Plex Sans font may not be loaded');
    if (!hasJetBrains) warnings.push('JetBrains Mono font may not be loaded');

    // 2. Check register backgrounds (paper vs terminal)
    const registers = await page.evaluate(() => {
      const paperEls = document.querySelectorAll('.paper-register');
      const termEls = document.querySelectorAll('.term-register, .term-frame');
      
      const paperColors = [...paperEls].slice(0, 3).map(el => {
        const s = getComputedStyle(el);
        return { bg: s.backgroundColor, el: el.className };
      });
      const termColors = [...termEls].slice(0, 3).map(el => {
        const s = getComputedStyle(el);
        return { bg: s.backgroundColor, el: el.className };
      });
      return { paperColors, termColors };
    });

    // Verify paper is light and terminal is dark
    if (registers.paperColors.length > 0) {
      const [r, g, b] = registers.paperColors[0].bg.match(/\d+/g).map(Number);
      const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
      if (luminance < 0.5) warnings.push(`Paper register bg too dark: ${registers.paperColors[0].bg}`);
    }
    if (registers.termColors.length > 0) {
      const [r, g, b] = registers.termColors[0].bg.match(/\d+/g).map(Number);
      const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
      if (luminance > 0.5) warnings.push(`Terminal register bg too light: ${registers.termColors[0].bg}`);
    }

    // 3. Check seam visibility and position
    const seamCheck = await page.evaluate(() => {
      const seams = document.querySelectorAll('.seam');
      return [...seams].map(s => {
        const r = s.getBoundingClientRect();
        const cs = getComputedStyle(s);
        return {
          visible: r.width > 0 && r.height > 0,
          width: r.width,
          height: r.height,
          x: r.x,
          y: r.y,
          bgColor: cs.backgroundColor,
          boxShadow: cs.boxShadow,
        };
      });
    });

    if (seamCheck.length === 0) warnings.push('No .seam elements found');
    else {
      for (const seam of seamCheck) {
        if (!seam.visible) warnings.push(`Seam element not visible: w=${seam.width} h=${seam.height}`);
        if (vp.name === 'desktop' && seam.width > 5) warnings.push(`Desktop seam too wide: ${seam.width}px (should be 1-2px)`);
        if (vp.name === 'desktop' && seam.height < 100) warnings.push(`Desktop seam too short: ${seam.height}px`);
      }
    }

    // 4. Check nav visibility and terminal styling
    const navCheck = await page.evaluate(() => {
      const nav = document.querySelector('.masthead');
      if (!nav) return null;
      const r = nav.getBoundingClientRect();
      const s = getComputedStyle(nav);
      return {
        visible: r.height > 0 && r.y >= -100,
        height: r.height,
        bg: s.backgroundColor,
        fontFamily: s.fontFamily,
        sticky: s.position === 'sticky' || s.position === 'fixed',
        hasBackdropBlur: s.backdropFilter.includes('blur'),
      };
    });

    if (!navCheck) errors.push('No .masthead nav found');
    else {
      if (!navCheck.sticky) warnings.push('Nav is not sticky/fixed');
      if (vp.name === 'desktop' && !navCheck.hasBackdropBlur) warnings.push('Nav missing backdrop-blur');
    }

    // 5. Check hero headline exists and has Fraunces
    const heroCheck = await page.evaluate(() => {
      const h2 = document.querySelector('.hero h2, .scene--hero h2');
      if (!h2) return null;
      const s = getComputedStyle(h2);
      return {
        text: h2.textContent.substring(0, 80),
        fontFamily: s.fontFamily,
        fontSize: s.fontSize,
        fontWeight: s.fontWeight,
        color: s.color,
        visible: h2.getBoundingClientRect().height > 0,
      };
    });

    if (!heroCheck) errors.push('No hero h2 found');
    else {
      if (!heroCheck.visible) warnings.push('Hero h2 not visible');
      if (!heroCheck.fontFamily.includes('Fraunces')) warnings.push(`Hero h2 not using Fraunces: ${heroCheck.fontFamily}`);
    }

    // 6. Check terminal frames have proper structure (label + body, NO window dots)
    const termFrameCheck = await page.evaluate(() => {
      const frames = document.querySelectorAll('.term-frame');
      return [...frames].map(f => {
        const label = f.querySelector('.term-label');
        const body = f.querySelector('.term-body');
        // Check for window dots (should NOT exist)
        const dots = f.querySelectorAll('.window-dot, .dot, [class*="dot"]');
        return {
          hasLabel: !!label,
          hasBody: !!body,
          hasWindowDots: dots.length > 0,
          labelBg: label ? getComputedStyle(label).backgroundColor : null,
        };
      });
    });

    if (termFrameCheck.some(f => f.hasWindowDots)) errors.push('Terminal frames have window dots (gate 47 violation)');
    if (termFrameCheck.some(f => !f.hasLabel || !f.hasBody)) warnings.push('Some terminal frames missing label or body');

    // 7. Check accent color usage (phosphor green)
    const accentCheck = await page.evaluate(() => {
      const accentEls = document.querySelectorAll('[class*="accent"]');
      const greenText = document.querySelectorAll('.stream-out--add, .syn-add, .syn-cmd');
      return {
        accentElements: accentEls.length,
        greenTextElements: greenText.length,
        sampleGreen: greenText.length > 0 ? getComputedStyle(greenText[0]).color : null,
      };
    });

    // 8. Check form exists in waitlist
    const formCheck = await page.evaluate(() => {
      const form = document.querySelector('form');
      if (!form) return null;
      const input = form.querySelector('input');
      const submit = form.querySelector('button, [type="submit"]');
      return {
        exists: true,
        hasInput: !!input,
        hasSubmit: !!submit,
        inputType: input ? input.type : null,
        action: form.action,
      };
    });

    if (!formCheck) warnings.push('No form found on page');
    else if (!formCheck.hasInput || !formCheck.hasSubmit) warnings.push('Form missing input or submit');

    // 9. Check footer colophon
    const footerCheck = await page.evaluate(() => {
      const footer = document.querySelector('footer');
      if (!footer) return null;
      return {
        text: footer.textContent.substring(0, 120),
        fontFamily: getComputedStyle(footer).fontFamily,
        bg: getComputedStyle(footer).backgroundColor,
      };
    });

    if (!footerCheck) warnings.push('No footer found');
    else if (!footerCheck.fontFamily.includes('JetBrains')) warnings.push(`Footer not in JetBrains Mono: ${footerCheck.fontFamily}`);

    // 10. Check horizontal overflow
    const overflowCheck = await page.evaluate(() => {
      return document.documentElement.scrollWidth <= document.documentElement.clientWidth + 2;
    });

    if (!overflowCheck) errors.push('Horizontal overflow detected');

    // 11. Check that the page has enough content sections
    const sectionCount = await page.evaluate(() => {
      return document.querySelectorAll('.scene').length;
    });

    if (sectionCount < 5) warnings.push(`Only ${sectionCount} .scene sections found (expected ~6)`);

    results.push({
      viewport: vp.name,
      dimensions: `${vp.w}x${vp.h}`,
      errors,
      warnings,
      sections: sectionCount,
      seamElements: seamCheck.length,
      terminalFrames: termFrameCheck.length,
    });
  }

  await browser.close();

  // Summary
  let totalErrors = 0;
  let totalWarnings = 0;
  for (const r of results) {
    totalErrors += r.errors.length;
    totalWarnings += r.warnings.length;
    console.log(`\n--- ${r.viewport.toUpperCase()} (${r.dimensions}) ---`);
    console.log(`  Sections: ${r.sections} | Seams: ${r.seamElements} | Term frames: ${r.terminalFrames}`);
    if (r.errors.length === 0) console.log('  ✅ No errors');
    else { console.log('  ❌ Errors:'); r.errors.forEach(e => console.log(`     - ${e}`)); }
    if (r.warnings.length === 0) console.log('  ✅ No warnings');
    else { console.log('  ⚠️  Warnings:'); r.warnings.forEach(w => console.log(`     - ${w}`)); }
  }

  console.log(`\n=== TOTAL: ${totalErrors} errors, ${totalWarnings} warnings ===`);
  process.exit(totalErrors > 0 ? 1 : 0);
}

qa().catch(e => { console.error(e); process.exit(1); });
