/* pagepacket - restrained landing interactions */

const prefersReducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
const revealTargets = document.querySelectorAll(".reveal");
const waitlistForms = document.querySelectorAll("[data-waitlist-form]");

if (!prefersReducedMotion && revealTargets.length > 0) {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      });
    },
    { threshold: 0.14, rootMargin: "0px 0px -48px 0px" }
  );

  revealTargets.forEach((target) => observer.observe(target));
}

function setFormState(form, state, message) {
  const status = form.querySelector("[data-form-message]");
  form.dataset.state = state;
  if (status) status.textContent = message;
}

waitlistForms.forEach((form) => {
  form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const input = form.querySelector('input[type="email"]');
    const email = input?.value.trim() ?? "";

    if (!input?.checkValidity()) {
      setFormState(form, "error", "Enter a valid email address to join the waitlist.");
      input?.focus();
      return;
    }

    setFormState(form, "loading", "Adding you to the waitlist...");

    const endpoint = form.getAttribute("action");

    if (!endpoint || endpoint === "/waitlist") {
      const saved = JSON.parse(localStorage.getItem("pagepacket-waitlist-preview") || "[]");
      const next = Array.from(new Set([...saved, email]));
      localStorage.setItem("pagepacket-waitlist-preview", JSON.stringify(next));
      setFormState(form, "success", "Saved in this browser. Connect /waitlist before launch.");
      form.reset();
      return;
    }

    try {
      const response = await fetch(endpoint, {
        method: form.getAttribute("method") || "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });

      if (!response.ok) throw new Error("Waitlist request failed");

      setFormState(form, "success", "You’re on the waitlist. I’ll send early access when it’s ready.");
      form.reset();
    } catch {
      setFormState(form, "error", "The waitlist did not save. Try again, or check the form endpoint.");
    }
  });
});
