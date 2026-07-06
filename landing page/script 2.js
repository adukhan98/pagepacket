/* ═══════════════════════════════════════════════════════════════
   pagepacket — Landing page interactions
   ═══════════════════════════════════════════════════════════════ */

// ── Nav scroll state ──────────────────────────────────────────
const navWrap = document.querySelector('.nav-wrap');

function handleScroll() {
  if (window.scrollY > 30) {
    navWrap.classList.add('scrolled');
  } else {
    navWrap.classList.remove('scrolled');
  }
}

window.addEventListener('scroll', handleScroll, { passive: true });
handleScroll();

// ── Scroll reveal animations ───────────────────────────────────
// Add .reveal class to elements we want to animate in
const revealTargets = [
  ...document.querySelectorAll('.step-card'),
  ...document.querySelectorAll('.feature-card'),
  ...document.querySelectorAll('.section-header'),
  ...document.querySelectorAll('.diff-demo'),
  ...document.querySelectorAll('.cli-demo'),
  ...document.querySelectorAll('.cta-card'),
  ...document.querySelectorAll('.backed-by'),
];

revealTargets.forEach(el => el.classList.add('reveal'));

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry, i) => {
      if (entry.isIntersecting) {
        // Stagger sibling reveals
        const siblings = entry.target.parentElement?.querySelectorAll('.reveal');
        let delay = 0;
        if (siblings) {
          const idx = Array.from(siblings).indexOf(entry.target);
          if (idx > 0) delay = idx * 80;
        }
        entry.target.style.transitionDelay = `${delay}ms`;
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.1, rootMargin: '0px 0px -60px 0px' }
);

revealTargets.forEach(el => observer.observe(el));

// ── Hero entrance animation ────────────────────────────────────
window.addEventListener('DOMContentLoaded', () => {
  const heroChildren = document.querySelectorAll('.hero-content > *');
  heroChildren.forEach((child, i) => {
    child.style.opacity = '0';
    child.style.transform = 'translateY(20px)';
    child.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    child.style.transitionDelay = `${0.1 + i * 0.12}s`;

    requestAnimationFrame(() => {
      child.style.opacity = '1';
      child.style.transform = 'translateY(0)';
    });
  });
});

// ── Smooth anchor scrolling with nav offset ────────────────────
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', (e) => {
    const href = anchor.getAttribute('href');
    if (href === '#' || href.length < 2) return;

    const target = document.querySelector(href);
    if (target) {
      e.preventDefault();
      const navHeight = 80;
      const top = target.getBoundingClientRect().top + window.scrollY - navHeight;
      window.scrollTo({ top, behavior: 'smooth' });
    }
  });
});

// ── Magnetic button effect (subtle) ────────────────────────────
document.querySelectorAll('.btn-primary').forEach(btn => {
  btn.addEventListener('mousemove', (e) => {
    const rect = btn.getBoundingClientRect();
    const x = e.clientX - rect.left - rect.width / 2;
    const y = e.clientY - rect.top - rect.height / 2;
    btn.style.transform = `translate(${x * 0.15}px, ${y * 0.15}px)`;
  });

  btn.addEventListener('mouseleave', () => {
    btn.style.transform = '';
  });
});
