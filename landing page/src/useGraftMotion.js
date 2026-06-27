import { useLayoutEffect } from "react";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";

gsap.registerPlugin(ScrollTrigger);

const MOBILE_BREAKPOINT = "(max-width: 60rem)";

function getTerminalRevealLines(container) {
  const textNodes = gsap.utils.toArray(".js-stream-text", container);
  const lines = textNodes.map((node) => node.closest(".stream-line") || node);
  return [...new Set(lines)];
}

function streamTerminal(container, vars = {}) {
  const lines = getTerminalRevealLines(container);
  if (!lines.length) return null;

  const caret = container.querySelector(".stream-caret-line");
  const tl = gsap.timeline({
    defaults: { ease: "power2.out" },
    ...vars,
  });

  gsap.set(lines, {
    opacity: 0,
    y: 8,
    clipPath: "inset(0 100% 0 0)",
    willChange: "opacity, transform, clip-path",
  });

  if (caret) {
    gsap.set(caret, { opacity: 0 });
  }

  tl.to(lines, {
    opacity: 1,
    y: 0,
    clipPath: "inset(0 0% 0 0)",
    duration: 0.34,
    stagger: 0.11,
    clearProps: "willChange",
  });

  if (caret) {
    tl.to(caret, { opacity: 1, duration: 0.18 }, "-=0.08");
  }

  return tl;
}

export function useGraftMotion(scopeRef) {
  useLayoutEffect(() => {
    const scope = scopeRef.current;
    if (!scope) return undefined;

    const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const isMobile = window.matchMedia(MOBILE_BREAKPOINT).matches;
    const refreshTimers = [];
    let isActive = true;

    const scheduleRefresh = (delay) => {
      const timer = window.setTimeout(() => {
        if (isActive) ScrollTrigger.refresh();
      }, delay);
      refreshTimers.push(timer);
    };

    const ctx = gsap.context(() => {
      if (reduceMotion) {
        gsap.set(
          ".js-reveal, .js-hero-term, .js-problem-term, .js-workflow-term, .js-hero-form",
          { opacity: 1, clearProps: "transform,clipPath" }
        );
        gsap.set(".js-stream-text, .js-workflow-cmd, .js-files-tree", { opacity: 1 });
        return;
      }

      // ── Nav entrance ──
      gsap.fromTo(
        ".js-nav",
        { y: -16, opacity: 0 },
        { y: 0, opacity: 1, duration: 0.5, ease: "power3.out" }
      );

      // ── Hero load orchestration ──
      const heroTl = gsap.timeline({ defaults: { ease: "power3.out" } });

      heroTl
        .fromTo(
          ".hero-paper .js-reveal",
          { y: 22, opacity: 0 },
          { y: 0, opacity: 1, duration: 0.7, stagger: 0.12 }
        )
        .fromTo(
          ".js-hero-term",
          { y: 28, opacity: 0 },
          { y: 0, opacity: 1, duration: 0.8 },
          "-=0.45"
        );

      // Hero terminal streams in after the frame settles
      const heroTerm = scope.querySelector(".js-hero-term");
      if (heroTerm) {
        const streamTl = streamTerminal(heroTerm, { paused: true });
        if (streamTl) {
          heroTl.add(() => streamTl.play(), "-=0.3");
        }
      }

      // ── Generic reveals ──
      gsap.utils.toArray(".js-reveal").forEach((el) => {
        if (el.closest(".hero-paper")) return; // hero handled above
        gsap.fromTo(
          el,
          { y: 24, opacity: 0 },
          {
            y: 0,
            opacity: 1,
            duration: 0.7,
            ease: "power3.out",
            scrollTrigger: {
              trigger: el,
              start: "top 82%",
              once: true,
            },
          }
        );
      });

      // ── Problem terminal: stream on enter ──
      const problemTerm = scope.querySelector(".js-problem-term");
      if (problemTerm) {
        const problemTl = streamTerminal(problemTerm, { paused: true });
        if (problemTl) {
          ScrollTrigger.create({
            trigger: problemTerm,
            start: "top 72%",
            once: true,
            onEnter: () => problemTl.play(),
          });
        }
      }

      // ── Files terminal: stream on enter ──
      const filesTerm = scope.querySelector(".files-terminal");
      if (filesTerm) {
        const filesTl = streamTerminal(filesTerm, { paused: true });
        if (filesTl) {
          ScrollTrigger.create({
            trigger: filesTerm,
            start: "top 72%",
            once: true,
            onEnter: () => filesTl.play(),
          });
        }
      }

      // ── Workflow: desktop scroll-scrub, mobile stacked ──
      if (!isMobile) {
        const workflowTerm = document.querySelector(".js-workflow-term");
        const workflowCmds = gsap.utils.toArray(".js-workflow-cmd", workflowTerm);

        workflowCmds.forEach((cmd) => gsap.set(cmd, { opacity: 0.18 }));

        if (workflowTerm) {
          ScrollTrigger.create({
            trigger: ".workflow-split",
            start: "top 55%",
            end: "bottom 70%",
            scrub: 0.6,
            onUpdate: (self) => {
              const count = workflowCmds.length;
              const active = Math.min(
                count - 1,
                Math.floor(self.progress * count)
              );
              workflowCmds.forEach((cmd, i) => {
                gsap.to(cmd, {
                  opacity: i <= active ? 1 : 0.18,
                  duration: 0.25,
                  overwrite: "auto",
                });
              });
            },
          });
        }

        // Highlight the active paper stage in sync with the terminal
        const stages = gsap.utils.toArray(".js-workflow-stage");
        if (stages.length) {
          ScrollTrigger.create({
            trigger: ".workflow-stages",
            start: "top 55%",
            end: "bottom 70%",
            scrub: 0.6,
            onUpdate: (self) => {
              const count = stages.length;
              const active = Math.min(
                count - 1,
                Math.floor(self.progress * count)
              );
              stages.forEach((stage, i) => {
                stage.classList.toggle("is-active", i === active);
              });
            },
          });
        }
      } else {
        // Mobile: just reveal each terminal command in sequence
        gsap.utils.toArray(".js-workflow-cmd").forEach((cmd, i) => {
          gsap.fromTo(
            cmd,
            { opacity: 0, y: 12 },
            {
              opacity: 1,
              y: 0,
              duration: 0.5,
              ease: "power3.out",
              scrollTrigger: {
                trigger: cmd,
                start: "top 88%",
                once: true,
              },
            }
          );
        });
      }

      // ── Seam glow: subtle opacity pulse as each seam crosses viewport center ──
      gsap.utils.toArray(".js-seam").forEach((seam) => {
        const node = seam.querySelector(".seam-node");
        const line = seam.querySelector(".seam-line");
        if (!node || !line) return;

        gsap.fromTo(
          [line, node],
          { opacity: 0 },
          {
            opacity: 1,
            duration: 0.6,
            ease: "power2.out",
            scrollTrigger: {
              trigger: seam.closest(".scene"),
              start: "top 75%",
              once: true,
            },
          }
        );
      });

      // Refresh after fonts load so terminal masks and scroll triggers measure correctly
      if (document.fonts?.ready) {
        document.fonts.ready.then(() => {
          scheduleRefresh(60);
        });
      }

      scheduleRefresh(120);
    }, scope);

    const onResize = () => ScrollTrigger.refresh();
    window.addEventListener("resize", onResize);

    return () => {
      isActive = false;
      refreshTimers.forEach((timer) => window.clearTimeout(timer));
      ctx.revert();
      window.removeEventListener("resize", onResize);
    };
  }, [scopeRef]);
}
