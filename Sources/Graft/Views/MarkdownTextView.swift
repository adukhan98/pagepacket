import AppKit
import SwiftUI

struct MarkdownTextView: NSViewRepresentable {
    @Binding var text: String
    @Binding var selection: EditorSelection
    var font: NSFont
    var isEditable: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true

        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.drawsBackground = false
        textView.backgroundColor = .clear
        textView.textColor = NSColor(GraftTheme.ink)
        textView.insertionPointColor = NSColor(GraftTheme.pink)
        textView.selectedTextAttributes = [
            .backgroundColor: NSColor(GraftTheme.mint).withAlphaComponent(0.35)
        ]
        textView.textContainerInset = NSSize(width: 18, height: 18)
        textView.isRichText = false
        textView.importsGraphics = false
        textView.isGrammarCheckingEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.allowsUndo = true
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.minSize = NSSize(width: 0, height: 0)
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(
            width: scrollView.contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )

        scrollView.documentView = textView
        context.coordinator.textView = textView
        context.coordinator.configure(textView)
        context.coordinator.apply(text: text, selectedRange: selection.range, force: true)
        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        context.coordinator.parent = self
        guard let textView = scrollView.documentView as? NSTextView else { return }

        context.coordinator.configure(textView)

        if textView.string != text {
            context.coordinator.apply(text: text, selectedRange: selection.range, force: true)
        } else {
            context.coordinator.applySelectionIfNeeded(selection.range)
            context.coordinator.apply(text: text, selectedRange: textView.selectedRange(), force: context.coordinator.needsAttributeRefresh)
        }
    }

    @MainActor
    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MarkdownTextView
        weak var textView: NSTextView?

        private let highlighter = MarkdownSyntaxHighlighter()
        private var isApplying = false
        private var renderedText = ""
        private var renderedFont: NSFont?

        init(_ parent: MarkdownTextView) {
            self.parent = parent
        }

        var needsAttributeRefresh: Bool {
            renderedFont != parent.font
        }

        func configure(_ textView: NSTextView) {
            textView.isEditable = parent.isEditable
            textView.isSelectable = true
            textView.font = parent.font
        }

        func textDidChange(_ notification: Notification) {
            guard !isApplying, let textView else { return }
            let selectedRange = textView.selectedRange()
            parent.text = textView.string
            apply(text: textView.string, selectedRange: selectedRange, force: true)
            updateSelection(from: textView)
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard !isApplying, let textView else { return }
            updateSelection(from: textView)
        }

        func apply(text: String, selectedRange: NSRange, force: Bool) {
            guard let textView, force || renderedText != text || renderedFont != parent.font else { return }
            let safeRange = selectedRange.clamped(toUTF16Length: (text as NSString).length)

            isApplying = true
            textView.textStorage?.setAttributedString(highlighter.attributedString(from: text, font: parent.font))
            textView.setSelectedRange(safeRange)
            isApplying = false

            renderedText = text
            renderedFont = parent.font
            parent.selection = EditorSelection(range: safeRange, in: text)
        }

        func applySelectionIfNeeded(_ range: NSRange) {
            guard let textView else { return }
            let safeRange = range.clamped(toUTF16Length: (textView.string as NSString).length)
            guard textView.selectedRange() != safeRange else { return }

            isApplying = true
            textView.setSelectedRange(safeRange)
            isApplying = false
        }

        private func updateSelection(from textView: NSTextView) {
            parent.selection = EditorSelection(range: textView.selectedRange(), in: textView.string)
        }
    }
}
