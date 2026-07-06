import { useEffect } from "react";
import Lenis from "lenis";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";

gsap.registerPlugin(ScrollTrigger);

let lenisInstance = null;

export function scrollToTarget(target, options = {}) {
  if (!target) return;

  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  if (lenisInstance && !reduceMotion) {
    lenisInstance.scrollTo(target, {
      duration: 1.05,
      easing: (t) => 1 - Math.pow(1 - t, 4),
      offset: options.offset ?? 0,
    });
    return;
  }

  target.scrollIntoView({
    block: "start",
    inline: "nearest",
    behavior: reduceMotion ? "auto" : "smooth",
  });
}

function SmoothScrollProvider({ children }) {
  useEffect(() => {
    const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    if (reduceMotion) {
      lenisInstance = null;
      return undefined;
    }

    const lenis = new Lenis({
      duration: 1.05,
      smoothWheel: true,
      wheelMultiplier: 0.85,
      touchMultiplier: 1.15,
      anchors: false,
    });

    lenisInstance = lenis;

    const update = (time) => {
      lenis.raf(time * 1000);
    };

    lenis.on("scroll", ScrollTrigger.update);
    gsap.ticker.add(update);
    gsap.ticker.lagSmoothing(0);
    ScrollTrigger.refresh();

    return () => {
      gsap.ticker.remove(update);
      lenis.destroy();
      if (lenisInstance === lenis) lenisInstance = null;
    };
  }, []);

  return children;
}

export default SmoothScrollProvider;
