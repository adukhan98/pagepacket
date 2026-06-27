import React, { useEffect, useMemo, useRef, useState } from "react";
import SmoothScrollProvider, { scrollToTarget } from "./SmoothScrollProvider.jsx";
import { useGraftMotion } from "./useGraftMotion.js";

const heroHelper = "early access for the local-first mac app. no cloud account required.";

// Hero terminal stream, framed as preview output rather than exact CLI proof.
const heroStream = [
  { out: "# 1 review pass before commit", kind: "muted" },
  { prompt: "$", cmd: "graft status ./notes", muted: false },
  { out: "3 markdown files touched", kind: "pending" },
  { out: "agent edits waiting", kind: "pending" },
  { prompt: "$", cmd: "graft snapshot ./notes", muted: false },
  { out: "local checkpoint saved", kind: "ok" },
  { prompt: "$", cmd: "graft review ./notes", muted: false },
  { out: "review before your next commit", kind: "ok" },
  { caret: true },
];

// Problem terminal stream — illustrative invisible edits.
const problemStream = [
  { out: "# codex · 14:02", kind: "muted" },
  { out: "+ ## launch plan", kind: "add" },
  { out: "- ship v1 soon.", kind: "del" },
  { out: "+ ship v1 after the backend lands.", kind: "add" },
  { out: "+ add rollout notes before launch.", kind: "add" },
  { out: "# cursor · 14:04", kind: "muted" },
  { out: "+ see also: ./risks.md", kind: "add" },
  { out: "# shell script · 14:09", kind: "muted" },
  { out: "- ## todo", kind: "del" },
  { out: "+ ## todos (resolved)", kind: "add" },
  { out: "files touched · waiting for review", kind: "pending" },
];

// Workflow stages — paper voice
const workflowStages = [
  {
    label: "write the intent",
    title: "keep 1 folder",
    body: "your specs, notes, and launch plans stay in the folder git, scripts, and agents already use.",
    cmd: "graft status ./notes",
    note: "human draft",
  },
  {
    label: "let the agent work",
    title: "avoid 2 drafts",
    body: "codex, claude code, cursor, and scripts edit the same markdown, so you stop copying text between tools.",
    cmd: "codex edits ./notes/launch-plan.md",
    note: "agent pass",
  },
  {
    label: "inspect the trail",
    title: "review in 1 pass",
    body: "scan the agent change before it replaces your draft. keep the line you meant, reject the line you did not ask for.",
    cmd: "graft history ./notes/launch-plan.md",
    note: "review queue",
  },
  {
    label: "keep the source",
    title: "ship with a trail",
    body: "your files still open anywhere, and graft leaves a local record you can inspect after the commit.",
    cmd: "git commit -m \"ship v1\"",
    note: "plain files",
  },
];

// Plain files ledger — terminal tree + paper reasons
const fileRows = [
  {
    path: "*.md",
    desc: "your notes, specs, docs, and plans stay as markdown.",
    reason: "you can open them anywhere, commit them to git, and hand them to an agent without exporting a thing.",
    tree: ["notes/", "  launch-plan.md", "  agents.md", "  risks.md"],
  },
  {
    path: ".graft/history",
    desc: "a local record of meaningful changes.",
    reason: "you get a way back when a broad edit changes more than you asked for.",
    tree: [".graft/", "  history/", "    before-agent.snapshot", "    latest.snapshot"],
  },
  {
    path: ".graft/reviews",
    desc: "local descriptions of proposed edits.",
    reason: "you see what changed before the agent rewrite becomes your draft.",
    tree: [".graft/", "  reviews/", "    agent-review.packet", "    status.json"],
  },
];

function App() {
  const scopeRef = useRef(null);
  const [email, setEmail] = useState("");
  const [touched, setTouched] = useState(false);
  const [status, setStatus] = useState("idle");

  useGraftMotion(scopeRef);

  useEffect(() => {
    const timers = [];

    function alignHash() {
      if (!window.location.hash) return;
      const target = document.querySelector(window.location.hash);
      if (target) scrollToTarget(target, { offset: -8 });
    }

    function scheduleAlignHash() {
      timers.push(window.setTimeout(alignHash, 80));
      timers.push(window.setTimeout(alignHash, 320));
    }

    scheduleAlignHash();
    document.fonts?.ready.then(alignHash);
    window.addEventListener("hashchange", scheduleAlignHash);
    return () => {
      timers.forEach((timer) => window.clearTimeout(timer));
      window.removeEventListener("hashchange", scheduleAlignHash);
    };
  }, []);

  const emailState = useMemo(() => {
    if (!touched || !email) return "default";
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ? "success" : "error";
  }, [email, touched]);

  function handleEmailChange(value) {
    setEmail(value);
    if (status !== "loading") setStatus("idle");
  }

  function handleSubmit(event) {
    event.preventDefault();
    setTouched(true);

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setStatus("error");
      return;
    }

    setStatus("loading");
    window.setTimeout(() => setStatus("success"), 650);
  }

  const formProps = {
    email,
    setEmail: handleEmailChange,
    touched,
    setTouched,
    emailState,
    status,
    handleSubmit,
  };

  return (
    <SmoothScrollProvider>
      <div className="graft-page" ref={scopeRef}>
        <Nav />
        <main>
          <Hero {...formProps} />
          <Problem />
          <Workflow />
          <PlainFiles />
          <Waitlist {...formProps} />
        </main>
        <Footer />
      </div>
    </SmoothScrollProvider>
  );
}

function scrollToHash(event) {
  const href = event.currentTarget.getAttribute("href");
  if (!href?.startsWith("#")) return;
  const target = document.querySelector(href);
  if (!target) return;

  event.preventDefault();
  scrollToTarget(target, { offset: -8 });
  window.history.pushState(null, "", href);
}

function Nav() {
  return (
    <header className="masthead js-nav" aria-label="Primary">
      <pre className="nav-term" aria-label="graft navigation">
        <span className="term-prompt">$</span>{" "}
        <span className="term-cmd">graft</span>{" "}
        <a href="#waitlist" onClick={scrollToHash} className="term-flag term-flag--accent">--join</a>
        <span className="term-caret js-nav-caret" aria-hidden="true">▮</span>
      </pre>
    </header>
  );
}

// A typographic-framed terminal column. Top rule + label only — NO fake window chrome.
function TerminalFrame({ label, children, className = "" }) {
  return (
    <div className={`term-frame ${className}`}>
      <div className="term-label" aria-hidden="true">
        <span className="term-label-path">{label}</span>
        <span className="term-label-dot">·</span>
        <span className="term-label-reg">terminal</span>
      </div>
      <pre className="term-body">{children}</pre>
    </div>
  );
}

function StreamLine({ line }) {
  if (line.caret) {
    return <span className="stream-line stream-caret-line"><span className="term-caret" aria-hidden="true">▮</span></span>;
  }
  if (line.prompt) {
    return (
      <span className="stream-line stream-cmd">
        <span className="term-prompt">{line.prompt}</span>{" "}
        <span className="term-cmd js-stream-text">{line.cmd}</span>
      </span>
    );
  }
  const kind = line.kind || "ok";
  return (
    <span className={`stream-line stream-out stream-out--${kind} js-stream-text`}>
      {line.out}
    </span>
  );
}

function Hero({ ...formProps }) {
  return (
    <section className="scene hero-split" id="top" aria-labelledby="hero-title">
      <Seam variant="hero" />
      <div className="split-grid split-grid--paper-lead">
        <div className="split-paper hero-paper">
          <h1 id="hero-title" className="js-reveal">
            review agent edits
            <br />
            <span className="hero-accent">in 1 pass.</span>
          </h1>
          <p className="hero-lede js-reveal">
            open your markdown folder, let codex, claude code, cursor, or a
            script edit it, then approve the changes before they touch your draft.
          </p>
          <div className="js-hero-form js-reveal">
            <WaitlistForm compact helper={heroHelper} {...formProps} />
          </div>
        </div>
        <div className="split-terminal hero-terminal js-hero-term">
          <TerminalFrame label="~/notes · preview">
            {heroStream.map((line, i) => <StreamLine key={i} line={line} />)}
          </TerminalFrame>
        </div>
      </div>
    </section>
  );
}

function Problem() {
  return (
    <section className="scene problem-split" id="agents" aria-labelledby="problem-title">
      <Seam variant="problem" />
      <div className="split-grid split-grid--term-lead">
        <div className="split-terminal problem-terminal js-problem-term">
          <TerminalFrame label="~/notes · invisible edits">
            {problemStream.map((line, i) => <StreamLine key={i} line={line} />)}
          </TerminalFrame>
        </div>
        <div className="split-paper problem-paper">
          <h2 id="problem-title" className="js-reveal">
            your markdown folder has 2 authors now.
          </h2>
          <p className="section-body js-reveal">
            you write the spec, then ask an agent to tighten it. 10 minutes
            later, 3 files changed, a heading moved, and the paragraph you
            cared about says something softer than you meant.
          </p>
          <p className="section-body js-reveal">
            now you are reading raw diffs like a crime scene. one small agent
            pass can turn into 20 minutes of checking what changed,
            what broke, and what you can still trust.
          </p>
        </div>
      </div>
    </section>
  );
}

function Workflow() {
  return (
    <section className="scene workflow-split" id="workflow" aria-labelledby="workflow-title">
      <Seam variant="workflow" />
      <div className="workflow-pin">
        <div className="split-grid split-grid--paper-lead">
          <div className="split-paper workflow-paper">
            <h2 id="workflow-title" className="js-reveal">
              turn every agent pass into 4 clear decisions.
            </h2>
            <p className="section-body js-reveal workflow-intro">
              keep the folder, let the agent work, review the changes, then
              commit plain markdown with a local trail.
            </p>
            <ol className="workflow-stages js-workflow-stages">
              {workflowStages.map((stage, i) => (
                <li key={stage.label} className="workflow-stage js-workflow-stage" data-stage={i}>
                  <span className="workflow-stage-num">{String(i + 1).padStart(2, "0")}</span>
                  <div className="workflow-stage-body">
                    <p className="workflow-stage-label">{stage.label}</p>
                    <h3>{stage.title}</h3>
                    <p className="workflow-stage-text">{stage.body}</p>
                  </div>
                  <span className="workflow-stage-note">{stage.note}</span>
                </li>
              ))}
            </ol>
          </div>
          <div className="split-terminal workflow-terminal js-workflow-term">
            <TerminalFrame label="~/notes · graft preview">
              {workflowStages.map((stage, i) => (
                <span key={i} className="stream-block js-workflow-cmd" data-stage={i}>
                  <span className="stream-line stream-cmd">
                    <span className="term-prompt">$</span>{" "}
                    <span className="term-cmd">{stage.cmd}</span>
                  </span>
                  <span className={`stream-line stream-out stream-out--${i === workflowStages.length - 1 ? "ok" : "pending"}`}>
                    {i === 0 && "local markdown folder detected"}
                    {i === 1 && "agent edits stay in plain files"}
                    {i === 2 && "local history gives you a trail"}
                    {i === 3 && "plain files preserved"}
                  </span>
                </span>
              ))}
            </TerminalFrame>
          </div>
        </div>
      </div>
    </section>
  );
}

function PlainFiles() {
  return (
    <section className="scene files-split" id="files" aria-labelledby="files-title">
      <Seam variant="files" />
      <div className="split-grid split-grid--term-lead">
        <div className="split-terminal files-terminal">
          <TerminalFrame label="~/notes · tree">
            <span className="stream-line stream-cmd">
              <span className="term-prompt">$</span>{" "}
              <span className="term-cmd js-stream-text">tree -L 2 .graft</span>
            </span>
            {fileRows.map((row, i) => (
              <span key={i} className="stream-block js-files-tree" data-row={i}>
                {row.tree.map((line, j) => (
                  <span key={j} className={`stream-line stream-out stream-out--tree js-stream-text`}>
                    {line}
                  </span>
                ))}
              </span>
            ))}
          </TerminalFrame>
        </div>
        <div className="split-paper files-paper">
          <h2 id="files-title" className="js-reveal">
            keep plain markdown. get the receipt.
          </h2>
          <p className="section-body js-reveal">
            graft records the context around shared work while your markdown
            stays portable. open files anywhere, commit them to git, and know
            what an agent tried to change.
          </p>
          <dl className="files-ledger">
            {fileRows.map((row, i) => (
              <div key={row.path} className="ledger-row js-reveal">
                <dt>{row.path}</dt>
                <dd>
                  <p className="ledger-desc">{row.desc}</p>
                  <p className="ledger-reason">{row.reason}</p>
                </dd>
              </div>
            ))}
          </dl>
        </div>
      </div>
    </section>
  );
}

function Waitlist({ ...formProps }) {
  return (
    <section className="scene waitlist-converge" id="waitlist" aria-labelledby="waitlist-title">
      <div className="converge-glow" aria-hidden="true" />
      <div className="converge-content js-reveal">
        <p className="paper-eyebrow converge-eyebrow">first build · local files · mac</p>
        <h2 id="waitlist-title" className="converge-title">
          join the waitlist before your next agent-written spec.
        </h2>
        <p className="converge-lede">
          if codex, claude code, cursor, or scripts already touch your markdown,
          graft gives you a review step before the next draft changes.
        </p>
        <p className="converge-lede converge-proof">
          product proof for the first build: plain files, local history, and
          review packets. no invented logos. no fake usage numbers.
        </p>
        <div className="converge-form">
          <WaitlistForm helper={heroHelper} {...formProps} />
        </div>
      </div>
    </section>
  );
}

function Seam({ variant }) {
  return (
    <div className={`seam seam--${variant} js-seam`} aria-hidden="true">
      <span className="seam-line" />
      <span className="seam-node" />
    </div>
  );
}

function WaitlistForm({
  email,
  setEmail,
  setTouched,
  emailState,
  status,
  handleSubmit,
  compact = false,
  helper,
}) {
  const helperText =
    status === "success"
      ? "you're on the early access list. i'll use this email when the first waitlist build is ready."
      : status === "error" || emailState === "error"
        ? "that email needs an @ and a domain. fix it, then save your spot."
        : helper;

  const inputId = compact ? "hero-email" : "footer-email";
  const helperId = compact ? "hero-email-helper" : "footer-email-helper";

  return (
    <form
      className={compact ? "waitlist-form waitlist-form--compact" : "waitlist-form"}
      onSubmit={handleSubmit}
      noValidate
    >
      <label className="form-prompt" htmlFor={inputId} aria-label="join the waitlist">
        <span className="term-prompt">$</span> graft --join
      </label>
      <div className="form-row" data-state={emailState} data-status={status}>
        <input
          id={inputId}
          type="email"
          aria-label="join the waitlist"
          inputMode="email"
          autoComplete="email"
          value={email}
          placeholder="name@company.com"
          aria-invalid={emailState === "error"}
          aria-describedby={helperId}
          onBlur={() => setTouched(true)}
          onChange={(event) => setEmail(event.target.value)}
        />
        <button type="submit" disabled={status === "loading"} className="form-submit">
          {status === "loading" ? "saving spot" : status === "success" ? "spot saved" : "save my spot"}
        </button>
      </div>
      <p className="form-helper" id={helperId} role={emailState === "error" ? "alert" : undefined}>
        {helperText}
      </p>
    </form>
  );
}

// Ft4 · Dense typographic colophon — mono register, closes the page
function Footer() {
  return (
    <footer className="colophon" aria-label="Site footer">
      <pre className="colophon-block" aria-hidden="false">
        <span className="colophon-line">
          <span className="term-prompt">$</span> graft --about
        </span>
        <span className="colophon-line colophon-out">graft preview · local-first mac markdown editor</span>
        <span className="colophon-line">
          plain files / local history / agent handoff / review before replace
        </span>
        <span className="colophon-line colophon-meta">
          made by adnaan · 2026 · no cloud account required
        </span>
      </pre>
    </footer>
  );
}

export default App;
