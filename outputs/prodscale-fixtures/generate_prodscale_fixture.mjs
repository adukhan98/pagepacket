import fs from "node:fs/promises";
import path from "node:path";

const repoRoot = path.resolve(import.meta.dirname, "../..");
const fixtureRoot = path.join(import.meta.dirname, "pagepacket-prodscale-vault");
const manifestPath = path.join(import.meta.dirname, "manifest.json");

const sections = [
  "product/specs",
  "product/research",
  "engineering/rfcs",
  "engineering/runbooks",
  "customer-notes",
  "meetings/2026/q1",
  "meetings/2026/q2",
  "knowledge/base",
  "knowledge/field-notes",
  "archive/2025",
  "nested/very/deep/workspace",
  "drafts"
];

const markdownBlocks = [
  "# {title}",
  "",
  "Owner: sanitized-{owner}@example.test",
  "Status: draft",
  "",
  "This generated document is safe local test data for Pagepacket. It avoids customer, account, and production content.",
  "",
  "## Summary",
  "",
  "The file exercises Markdown editing, preview rendering, snapshot history, external-agent edits, and CLI traversal under a production-scale folder tree.",
  "",
  "## Checklist",
  "",
  "- [ ] Verify edit mode",
  "- [x] Keep Markdown plain",
  "- [ ] Review agent changes before accepting",
  "",
  "## Table",
  "",
  "| Area | State | Risk |",
  "| --- | --- | --- |",
  "| app | active | medium |",
  "| cli | active | low |",
  "| landing | preview | medium |",
  "",
  "## Quote",
  "",
  "> Human review remains the boundary before agent edits become canonical.",
  "",
  "## Code",
  "",
  "```sh",
  "pagepacket-cli snapshot . {relative} --message \"Before agent edits\"",
  "```",
  "",
  "![Sample asset](../assets/shared/sample.ppm)",
  "",
  "---",
  "",
  "A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: {longLine}",
  ""
];

function pad(value, width = 3) {
  return String(value).padStart(width, "0");
}

function docContent(index, relative) {
  const title = path.basename(relative, ".md").replaceAll("-", " ");
  return markdownBlocks
    .join("\n")
    .replaceAll("{title}", title)
    .replaceAll("{owner}", `owner-${pad(index)}`)
    .replaceAll("{relative}", relative)
    .replaceAll(
      "{longLine}",
      Array.from({ length: 48 }, (_, item) => `token-${pad(index)}-${pad(item)}`).join(" ")
    );
}

async function writeText(filePath, content) {
  await fs.mkdir(path.dirname(filePath), { recursive: true });
  await fs.writeFile(filePath, content, "utf8");
}

async function writeSampleImage() {
  const ppm = [
    "P3",
    "8 8",
    "255",
    "255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0",
    "26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245",
    "255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0",
    "26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245",
    "255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0",
    "26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245",
    "255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0 255 233 92 26 51 0",
    "26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245 26 51 0 255 250 245"
  ].join("\n");
  await writeText(path.join(fixtureRoot, "assets/shared/sample.ppm"), ppm);
}

async function main() {
  const normalizedRoot = path.resolve(fixtureRoot);
  if (!normalizedRoot.startsWith(path.resolve(repoRoot, "outputs/prodscale-fixtures"))) {
    throw new Error(`Refusing to rebuild fixture outside outputs/prodscale-fixtures: ${normalizedRoot}`);
  }

  await fs.rm(fixtureRoot, { recursive: true, force: true });
  await fs.mkdir(fixtureRoot, { recursive: true });
  await writeSampleImage();

  const files = [];
  let index = 1;
  for (const section of sections) {
    for (let item = 1; item <= 30; item += 1) {
      const relative = path.join(section, `note-${pad(item)}.md`);
      await writeText(path.join(fixtureRoot, relative), docContent(index, relative));
      files.push(relative);
      index += 1;
    }
  }

  const edgeFiles = [
    ["root-overview.md", "# Root overview\n\nA root-level Markdown file.\n"],
    ["drafts/empty.md", ""],
    ["drafts/a__b.md", "# Flat collision candidate\n"],
    ["drafts/a/b.md", "# Nested collision candidate\n"],
    ["drafts/file with spaces.md", "# Spaces\n\nFilename with spaces.\n"],
    ["nested/very/deep/workspace/long-line.md", docContent(index, "nested/very/deep/workspace/long-line.md")]
  ];

  for (const [relative, content] of edgeFiles) {
    await writeText(path.join(fixtureRoot, relative), content);
    files.push(relative);
    index += 1;
  }

  await writeText(
    path.join(fixtureRoot, ".pagepacket/shares/invites.json"),
    JSON.stringify(
      [
        { id: "00000000-0000-4000-8000-000000000001", email: "editor@example.test", role: "editor", createdAt: "2026-01-01T00:00:00Z" },
        { id: "00000000-0000-4000-8000-000000000002", email: "viewer@example.test", role: "viewer", createdAt: "2026-01-02T00:00:00Z" }
      ],
      null,
      2
    )
  );
  await writeText(path.join(fixtureRoot, ".pagepacket/history/ignored.md"), "# Hidden sidecar Markdown\n");
  await writeText(path.join(fixtureRoot, ".graft/history/legacy-hidden.md"), "# Legacy hidden sidecar Markdown\n");

  const manifest = {
    generatedBy: "outputs/prodscale-fixtures/generate_prodscale_fixture.mjs",
    safety: "sanitized local-only data; no production, account, customer, or sensitive content",
    fixtureRoot,
    markdownFileCount: files.length,
    visibleMarkdownFileCount: files.length,
    sidecarMarkdownFiles: 2,
    sections: sections.length,
    edgeCases: [
      "empty Markdown file",
      "deeply nested Markdown file",
      "filename with spaces",
      "long lines for editor wrapping",
      "path-collision candidates drafts/a/b.md and drafts/a__b.md",
      "relative image paths",
      "hidden .pagepacket and legacy .graft sidecar Markdown files",
      "persisted invite manifest with sanitized example.test addresses"
    ],
    files
  };

  await writeText(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
  console.log(`generated ${files.length} visible Markdown files at ${fixtureRoot}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
