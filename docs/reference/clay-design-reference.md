## Overview

pagepacket speaks the visual language of a creative studio's moodboard: warm cream paper, a single deep forest green that does the heavy lifting for text and primary actions, and a vivid school-bus yellow that acts as both highlight marker and playful punctuation. Type is deliberately split-personality — Bricolage Grotesque at extrabold for display headlines with positive tracking that gives the words a sticker-book chunkiness, paired with Inter's clean humanist sans for everything functional. The landing page is waitlist-first: the first screen sells one concrete idea, shows a review packet artifact, and asks for an email address. The overall feel is approachable, hand-made, and slightly rebellious: rounded 6px corners everywhere, minimal shadows, scattered pastel accents that feel like sticky notes rather than generic SaaS cards.

**Key Characteristics:**
- Cream Paper (`#fcfaf5`) canvas throughout — warm off-white, slightly yellow-shifted to feel like aged paper. Never use pure white or cool-gray.
- Forest Ink (`#1a3300`) is the single chromatic workhorse — primary text, filled CTAs, links, borders. Never use pure black (`#000000`) for text.
- Highlighter Yellow (`#ffe95c`) as a background wash behind individual words in headlines (marker-pen effect), never as a CTA fill or full surface.
- Bricolage Grotesque 800 with positive letter-spacing (0.04–0.05em) for all display headlines — the signature voice. Never use below 40px.
- Inter for everything functional: body, nav, buttons, cards, subheadings.
- Roboto Mono for micro-labels, tags, and technical metadata.
- 6px radius for buttons, 12px for cards, 16px for nav — never mix sharp 0px corners with the rounded system.
- Minimal shadows — separate layers with color fills and 1px borders. Shadows reserved for nav glow and button lift only.
- Page is 95% cream + forest green. Pastel accents (Mint, Blush, Teal) appear as individual card or button fills, never as large surfaces.
- Waitlist conversion is the primary action. Use email forms above the fold and near the close; secondary links should only support product understanding.

## Colors

### Brand & Accent
- **Forest Ink** (`--color-forest-ink` — `#1a3300`): Primary text, filled CTA buttons, link text, nav borders, card borders — the structural backbone. This near-black green carries 90% of the interface weight.
- **Highlighter Yellow** (`--color-highlighter-yellow` — `#ffe95c`): Text highlight wash (behind keywords in headlines), badge backgrounds, accent fills. Always reads as a marker stroke, never as a CTA.

### Surface
- **Cream Paper** (`--color-cream-paper` — `#fcfaf5`): Page canvas, card surfaces, nav background — the warm off-white everything sits on.
- **Sticky Note Mint** (`--color-sticky-note-mint` — `#d5f5c2`): Green action color for filled buttons, selected navigation states, feature card surface.
- **Sticky Note Teal** (`--color-sticky-note-teal` — `#a8e5e5`): Teal action color for filled buttons, selected navigation states, decorative card surface.
- **Sticky Note Blush** (`--color-sticky-note-blush` — `#f6d0ff`): Decorative button/card fill. Sprinkle use only.
- **Highlighter Yellow** (`--surface-highlighter-yellow` — `#ffe95c`): Accent card or highlighted callout surface.

### Neutral
- **Pencil Gray** (`--color-pencil-gray` — `#b6b6b6`): Nav and divider borders — a single mid-gray for hairlines that should recede.
- **Whisper Gray** (`--color-whisper-gray` — `#f1f1f1`): Muted helper text, secondary labels — disappears into the cream canvas.
- **Terracotta** (`--color-terracotta` — `#cb5521`): Decorative card accent — warm counterpoint to the green/yellow palette.

### Surfaces (levels)
| Level | Name | Value | Purpose |
|-------|------|-------|---------|
| 1 | Cream Paper | `#fcfaf5` | Page canvas and nav background |
| 2 | Sticky Note Mint | `#d5f5c2` | Soft feature card surface |
| 3 | Highlighter Yellow | `#ffe95c` | Accent card or highlighted callout surface |
| 4 | Sticky Note Blush | `#f6d0ff` | Decorative card surface |
| 5 | Sticky Note Teal | `#a8e5e5` | Decorative card surface |

## Typography

### Font Families

**Bricolage Grotesque** (`--font-bricolage-grotesque`) — Display headlines only. Custom variable font with positive tracking (0.04–0.05em) that makes characters feel chunky and sticker-like. This is the signature voice — never use for body or UI.
- **Substitute:** Archivo Black, or Mulish 900 as fallback
- **Weights:** 800
- **Sizes:** 55px, 66px, 90px
- **Line height:** 1.00–1.20
- **Letter spacing:** 0.04em at 55px, 0.05em at 66–90px

**Inter** (`--font-inter`) — Everything functional: body copy, nav, buttons, cards, subheadings. Weight 400 for body, 500–600 for labels and subheads, 700 for section headings. Clean humanist sans that lets the Bricolage display type stay loud.
- **Substitute:** system-ui, -apple-system, Segoe UI
- **Weights:** 300, 400, 500, 600, 700
- **Sizes:** 11px, 12px, 14px, 16px, 17px, 18px, 20px, 24px, 28px, 30px, 32px, 36px, 38px, 40px, 64px
- **Line height:** 1.20–1.63

**Roboto Mono** (`--font-roboto-mono`) — Micro-labels in nav, small caps-style tags, and technical metadata. Mono signals 'tool/utility' context within the otherwise rounded typographic system.
- **Substitute:** JetBrains Mono, IBM Plex Mono
- **Weights:** 400
- **Sizes:** 12px, 15px, 16px
- **Line height:** 1.00–1.38

### Type Scale

| Role | Size | Line Height | Letter Spacing | Token |
|------|------|-------------|----------------|-------|
| micro | 11px | 1.3 | — | `--text-micro` |
| caption | 14px | 1.5 | — | `--text-caption` |
| body-sm | 16px | 1.5 | — | `--text-body-sm` |
| body | 18px | 1.5 | — | `--text-body` |
| body-lg | 20px | 1.38 | — | `--text-body-lg` |
| subheading | 28px | 1.25 | — | `--text-subheading` |
| heading-sm | 40px | 1.1 | — | `--text-heading-sm` |
| heading | 55px | 1 | 2.2px | `--text-heading` |
| heading-lg | 66px | 1 | 3.3px | `--text-heading-lg` |
| display | 90px | 1 | 4.5px | `--text-display` |

### Principles
- Bricolage Grotesque at 800 weight + positive letter-spacing IS the brand voice. Going below 800 weight or below 40px is a system violation.
- The body-vs-display split is functional: Bricolage for headlines, Inter for everything else. Mixing them is a system violation.
- Body copy sits at 18–20px Inter 400 with 1.5 line-height — comfortable-density reading experience.

## Spacing & Shapes

**Base unit:** 8px
**Density:** comfortable

### Spacing Scale

| Name | Value | Token |
|------|-------|-------|
| 8 | 8px | `--spacing-8` |
| 16 | 16px | `--spacing-16` |
| 24 | 24px | `--spacing-24` |
| 32 | 32px | `--spacing-32` |
| 40 | 40px | `--spacing-40` |
| 48 | 48px | `--spacing-48` |
| 56 | 56px | `--spacing-56` |
| 64 | 64px | `--spacing-64` |
| 80 | 80px | `--spacing-80` |
| 96 | 96px | `--spacing-96` |
| 120 | 120px | `--spacing-120` |

### Border Radius

| Element | Value |
|---------|-------|
| nav | 16px |
| tags | 9999px |
| cards | 12px |
| buttons | 6px |

### Shadows

| Name | Value | Token |
|------|-------|-------|
| subtle | `rgba(0, 0, 0, 0.05) 0px 1px 2px 0px` | `--shadow-subtle` |
| subtle-2 | `rgba(0, 0, 0, 0.1) 0px 1px 3px 0px, rgba(0, 0, 0, 0.1) 0px 1px 2px -1px` | `--shadow-subtle-2` |
| xl | `rgba(255, 235, 90, 0.01) 0px 527px 211px 0px, rgba(255, 235, 90, 0.05) 0px 297px 178px 0px, rgba(255, 235, 90, 0.09) 0px 132px 132px 0px, rgba(255, 235, 90, 0.1) 0px 33px 72px 0px` | `--shadow-xl` |

## Layout

- **Page max-width:** 1200px
- **Section gap:** 64px
- **Card padding:** 24px
- **Element gap:** 16px

Page layout is max-width 1200px with generous side padding and a workbench macrostructure. The hero is asymmetric: a left-biased waitlist pitch and email form paired with a right-side review packet artifact. The packet mockup is the visual proof, not decoration. Sections stack vertically without alternating dark/light bands; the cream canvas is consistent throughout. Feature sections use varied spans, rows, and tabular flow instead of a generic 3-card row. The navigation sits in a floating rounded container with an inline command/search pill, not a full-width bar. The overall rhythm is spacious, but conversion remains close: above-fold waitlist form, product proof, final waitlist form.

## Elevation

- **Primary CTA Button:** `rgba(0, 0, 0, 0.05) 0px 1px 2px 0px`
- **Secondary Button (hover/active):** `rgba(0, 0, 0, 0.1) 0px 1px 3px 0px, rgba(0, 0, 0, 0.1) 0px 1px 2px -1px`
- **Nav bar:** The unusual multi-layer yellow shadow glow (`--shadow-xl`) that bleeds beyond the nav edges.

The system uses no heavy shadows. Depth comes from color fills and 1px borders, not drop shadows. Shadows above 2px blur break the flat aesthetic.

## Imagery

Imagery is minimal and hand-crafted rather than photographic. The system uses black-line sketch illustrations at reduced opacity (~15%) as atmospheric background elements — abstract shapes, partial drawings, and gestural marks that feel like a designer's notebook scribbles bleeding off the page. There is no product photography, no stock imagery, no 3D renders. Decorative elements are monoline (1–2px stroke), unfilled, and deliberately imperfect. The logo mark itself is hand-drawn. Iconography in the interface is small and functional, appearing mostly in the tagline badge and feature card contexts. The overall image density is low — the page is text-dominant with illustration serving as texture rather than content.

## Components

### Primary CTA Button
**Role:** Conversion action

Filled Forest Ink (`#1a3300`) background, Cream Paper (`#fcfaf5`) text, 6px radius, padding 14px 22px (or 10px 16px for compact). Inter 700 at 14–16px. Subtle shadow only. Primary labels should be waitlist verbs: `Join waitlist`, `Request access`, or `Get early access`.

### Waitlist Form
**Role:** Primary conversion surface

One labelled email field and one one-line submit button. Label sits above the input. Helper text sits below the row and should be concrete, e.g. `Early macOS build. No newsletter churn.` Error text appears below helper text and names the fix: `Enter a valid email address to join the waitlist.` Success text is quiet and factual. The form has all states: default, focus, active submit, loading, error, success, and disabled-ready styling. The current static landing page uses `/waitlist` as the replaceable action endpoint.

### Outline Nav Button
**Role:** Secondary nav action

Transparent fill, 1px Forest Ink border, 6px radius, padding 8px 16px. Inter 500 at 14px in Forest Ink. Used for 'Log In' in nav.

### Pastel Accent Button
**Role:** Playful secondary action

Filled with one of the sticky-note pastels (Blush, Teal, Mint), Forest Ink text at 14–16px Inter 500, 6px radius. Used for demo/secondary paths where a green CTA would feel too committed.

### Highlighted Word
**Role:** Editorial emphasis within display text

Individual words or short phrases in a Bricolage Grotesque headline wrapped in a Highlighter Yellow (`#ffe95c`) background. The highlight is a rectangular wash behind the text, not a border. Creates a marker-pen effect.

### Logo Mark
**Role:** Brand identity

Two-part lockup: a 40x40 square in Highlighter Yellow containing a hand-drawn folded-packet illustration in Forest Ink (rounded, slightly imperfect strokes), followed by 'pagepacket' wordmark in Inter 700 at 20px in Forest Ink.

### Sticky Note Card
**Role:** Feature or decorative surface

12–16px radius, 24–28px padding, filled with one of the pastel accents (Mint, Blush, Teal, Terracotta) or Cream Paper. Forest Ink text. Optional 1px Forest Ink border. No shadow — the color fill does the separation work.

### Top Navigation Bar
**Role:** Primary site navigation

Cream Paper background, 16px radius container (pill-shaped), 1px Pencil Gray border. Logo left, centered nav links (Inter 500, 14px), auth buttons right. Padding 8–12px vertical. Contains the unusual multi-layer yellow shadow glow that bleeds beyond the nav edges. Floating — centered at top with margin, not full-width bar.

### Tagline Badge
**Role:** Eyebrow label above headline

Small pill or rounded rectangle with a tiny icon (lightbulb/star), Highlighter Yellow background, Forest Ink text at 12–14px Inter 500. Sits centered above the display headline as a 'category marker'.

### Review Packet Artifact
**Role:** Product proof

The hero visual is a code-native review packet: file title, status chip, Markdown hunk lines, added/removed/conflict states, and review actions. It should never use fake browser chrome. It is a product artifact, not an illustration. Use Forest Ink borders, Cream Paper surfaces, Mint for additions, Terracotta for removals, and Highlighter Yellow for conflicts.

### Display Hero Headline
**Role:** Page-level title

Bricolage Grotesque 800 at 66–90px, Forest Ink color, line-height 1.0, letter-spacing 0.04–0.05em. One or two words within the headline get the Highlighter Yellow background treatment.

### Subhead Paragraph
**Role:** Hero supporting copy

Inter 400 at 18–20px, Forest Ink color, line-height 1.5, max-width ~620px, left-aligned in the hero. The subhead must state the waitlist value and the product boundary: plain Markdown files, local review packets, human decision before agent edits land.

### Reassurance Caption
**Role:** Microcopy below CTA

Inter 400 at 12–14px, Whisper Gray (`#f1f1f1`) or Pencil Gray. Examples: 'no credit card required.' Sits 8–12px below the primary button.

### Decorative Sketch Element
**Role:** Atmospheric illustration

Hand-drawn line illustrations in Forest Ink at ~15% opacity, placed as background atmosphere in hero/transition zones. Sharp 1–2px strokes, no fill, slight imperfection in line quality. Not icons — mood.

## Do's and Don'ts

### Do
- Use Forest Ink (`#1a3300`) for all primary text, links, and CTA buttons — it is the single chromatic workhorse.
- Set display headlines in Bricolage Grotesque 800 with positive letter-spacing (0.04–0.05em); let it breathe at line-height 1.0.
- Apply Highlighter Yellow (`#ffe95c`) as a background wash behind individual words in headlines, not as a button fill or full surface.
- Use 6px radius for all buttons and 12px for cards — never mix sharp 0px corners with the rounded system.
- Set body copy at 18–20px Inter 400 with 1.5 line-height; this is a comfortable-density reading experience.
- Separate layers with color fills and 1px borders, not shadows. Shadows are reserved for the nav glow and button lift only.
- Keep the page 95% cream + forest green. Pastel accents (Mint, Blush, Teal) appear as individual card or button fills, never as large surfaces.
- Keep the waitlist form above the fold and repeat it once at the close.
- Show concrete product proof beside the first form: a review packet, a CLI command, or a real app capture.

### Don't
- Don't use Bricolage Grotesque for body text, nav, buttons, or anything below 40px — its 800 weight is too heavy for small sizes.
- Don't introduce a second primary brand color. Forest Ink is the only chromatic authority; everything else is accent or neutral.
- Don't apply heavy drop shadows. The system relies on color and borders for hierarchy; box-shadows above 2px blur break the flat aesthetic.
- Don't use pure black (`#000000`) for text. Forest Ink is the text color — pure black should only appear as SVG fill/stroke in decorative elements.
- Don't center-align body paragraphs wider than 640px. Headlines and subheads center, but reading copy should be left-aligned or constrained.
- Don't use Highlighter Yellow as a CTA background. It reads as a marker, not an action — reserve it for text highlight washes.
- Don't combine multiple pastel accent cards in the same row. Each pastel card should be separated by cream space to maintain the sticky-note rhythm.
- Don't split the main conversion between download, docs, GitHub, and waitlist. Until launch, waitlist is the only primary CTA.
- Don't fake social proof, waitlist counts, or launch dates. If a metric is unknown, omit it.

## Quick Reference

**Quick Color Reference**
- text: `#1a3300` (Forest Ink)
- background: `#fcfaf5` (Cream Paper)
- border: `#b6b6b6` (Pencil Gray)
- accent: `#ffe95c` (Highlighter Yellow)
- muted text: `#f1f1f1` (Whisper Gray)
- primary action: `#1a3300` (filled action)

## Similar Brands

- **Notion** — Same warm minimal canvas with a single near-black color carrying all structural weight, and intentional use of black-line illustration for atmospheric texture.
- **Linear** — Restrained chromatic palette, generous whitespace, and the confidence to let one bold display typeface carry the brand voice while keeping UI type quiet.
- **Framer** — Playful creative-tool aesthetic with rounded corners, yellow as an editorial highlight accent, and sketch-style illustration elements.
- **Pitch** — Same studio-moodboard visual language: cream/warm canvas, bold display type, pastel accent cards scattered like sticky notes, minimal shadow hierarchy.
