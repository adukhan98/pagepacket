import AppKit
import SwiftUI

struct MarkdownSyntaxHighlighter {
    func attributedString(from markdown: String, font: NSFont) -> NSAttributedString {
        let attributed = NSMutableAttributedString(
            string: markdown,
            attributes: [
                .font: font,
                .foregroundColor: NSColor(GraftTheme.ink),
                .paragraphStyle: paragraphStyle
            ]
        )

        applyLineAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"^#{1,6}\s+.*$"#,
            attributes: [
                .foregroundColor: NSColor(GraftTheme.teal),
                .font: NSFont.monospacedSystemFont(ofSize: font.pointSize + 1, weight: .semibold)
            ]
        )
        applyLineAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"^>\s?.*$"#,
            attributes: [
                .foregroundColor: NSColor(GraftTheme.muted),
                .font: italicFont(from: font)
            ]
        )
        applyCaptureAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"^(\s*(?:[-*+]|\d+\.)\s+)"#,
            captureIndex: 1,
            attributes: [
                .foregroundColor: NSColor(GraftTheme.pink),
                .font: NSFont.monospacedSystemFont(ofSize: font.pointSize, weight: .semibold)
            ]
        )
        applyCaptureAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"^(\s*[-*+]\s+\[[ xX]\])\s+"#,
            captureIndex: 1,
            attributes: [
                .foregroundColor: NSColor(GraftTheme.teal),
                .font: NSFont.monospacedSystemFont(ofSize: font.pointSize, weight: .semibold)
            ]
        )
        applyInlineAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"\!\[[^\]\n]*\]\([^\)\n]+\)"#,
            attributes: [
                .foregroundColor: NSColor(GraftTheme.teal),
                .font: NSFont.monospacedSystemFont(ofSize: font.pointSize, weight: .medium)
            ]
        )
        applyInlineAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"(?<!!)\[[^\]\n]+\]\([^\)\n]+\)"#,
            attributes: [
                .foregroundColor: NSColor(GraftTheme.lavender),
                .font: NSFont.monospacedSystemFont(ofSize: font.pointSize, weight: .medium)
            ]
        )
        applyInlineAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"`[^`\n]+`"#,
            attributes: [
                .foregroundColor: NSColor(GraftTheme.pink),
                .backgroundColor: NSColor(GraftTheme.surfaceCard)
            ]
        )
        applyInlineAttributes(
            to: attributed,
            markdown: markdown,
            pattern: #"^```[\s\S]*?(?:\n```|$)"#,
            options: [.anchorsMatchLines],
            attributes: [
                .foregroundColor: NSColor(GraftTheme.body),
                .backgroundColor: NSColor(GraftTheme.surfaceCard),
                .font: NSFont.monospacedSystemFont(ofSize: font.pointSize, weight: .regular)
            ]
        )

        return attributed
    }

    private var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        style.paragraphSpacing = 4
        return style
    }

    private func applyLineAttributes(
        to attributed: NSMutableAttributedString,
        markdown: String,
        pattern: String,
        attributes: [NSAttributedString.Key: Any]
    ) {
        applyInlineAttributes(
            to: attributed,
            markdown: markdown,
            pattern: pattern,
            options: [.anchorsMatchLines],
            attributes: attributes
        )
    }

    private func applyInlineAttributes(
        to attributed: NSMutableAttributedString,
        markdown: String,
        pattern: String,
        options: NSRegularExpression.Options = [],
        attributes: [NSAttributedString.Key: Any]
    ) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return }
        let fullRange = NSRange(markdown.startIndex..<markdown.endIndex, in: markdown)
        regex.enumerateMatches(in: markdown, range: fullRange) { match, _, _ in
            guard let range = match?.range, range.location != NSNotFound else { return }
            attributed.addAttributes(attributes, range: range)
        }
    }

    private func applyCaptureAttributes(
        to attributed: NSMutableAttributedString,
        markdown: String,
        pattern: String,
        captureIndex: Int,
        attributes: [NSAttributedString.Key: Any]
    ) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines]) else { return }
        let fullRange = NSRange(markdown.startIndex..<markdown.endIndex, in: markdown)
        regex.enumerateMatches(in: markdown, range: fullRange) { match, _, _ in
            guard let range = match?.range(at: captureIndex), range.location != NSNotFound else { return }
            attributed.addAttributes(attributes, range: range)
        }
    }

    private func italicFont(from font: NSFont) -> NSFont {
        NSFontManager.shared.convert(font, toHaveTrait: .italicFontMask)
    }
}
