import AppKit
import SwiftUI

struct MarkdownEditorView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(workspace.selectedFile?.title ?? "Untitled")
                        .font(.title2.weight(.semibold))
                    Text(workspace.selectedFile?.relativePath ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    workspace.insertImageFromPanel()
                } label: {
                    Label("Image", systemImage: "photo.badge.plus")
                }
                Button {
                    workspace.saveCurrentDocument()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(GraftTheme.surfaceSoft)

            WrappingMarkdownTextView(
                text: $workspace.editorText,
                fontSize: workspace.editorFontSize
            ) {
                    guard workspace.autosaveEnabled, workspace.isDirty else { return }
                    workspace.saveCurrentDocument()
                }
                .background(GraftTheme.canvas)
        }
    }
}

private struct WrappingMarkdownTextView: NSViewRepresentable {
    @Binding var text: String
    var fontSize: Double
    var onTextChange: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder

        let textView = HorizontalLockedTextView(frame: .zero)
        textView.delegate = context.coordinator
        textView.string = text
        textView.isRichText = false
        textView.importsGraphics = false
        textView.allowsUndo = true
        textView.drawsBackground = false
        textView.textContainerInset = NSSize(width: 18, height: 18)
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.heightTracksTextView = false
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.minSize = NSSize(width: 0, height: scrollView.contentSize.height)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.setSelectedRange(NSRange(location: 0, length: 0))
        applyStyle(to: textView)

        scrollView.documentView = textView
        DispatchQueue.main.async {
            updateTextContainer(in: scrollView)
            resetHorizontalScroll(in: scrollView)
        }
        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        context.coordinator.parent = self
        guard let textView = scrollView.documentView as? NSTextView else { return }

        if textView.string != text {
            let selectedRange = textView.selectedRange()
            context.coordinator.isUpdatingFromSwiftUI = true
            textView.string = text
            textView.setSelectedRange(clamped(selectedRange, to: text))
            context.coordinator.isUpdatingFromSwiftUI = false
        }

        textView.textContainer?.containerSize = NSSize(
            width: max(1, scrollView.contentSize.width - textView.textContainerInset.width * 2),
            height: CGFloat.greatestFiniteMagnitude
        )
        textView.frame.size.width = max(1, scrollView.contentSize.width)
        applyStyle(to: textView)
        resetHorizontalScroll(in: scrollView)
        DispatchQueue.main.async {
            resetHorizontalScroll(in: scrollView)
        }
    }

    private func applyStyle(to textView: NSTextView) {
        let font = NSFont.monospacedSystemFont(ofSize: CGFloat(fontSize), weight: .regular)
        textView.font = font
        textView.textColor = EditorPalette.body
        textView.insertionPointColor = EditorPalette.body
        textView.typingAttributes[.font] = font
        textView.typingAttributes[.foregroundColor] = EditorPalette.body
    }

    private func updateTextContainer(in scrollView: NSScrollView) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        textView.frame.size.width = max(1, scrollView.contentSize.width)
        textView.textContainer?.containerSize = NSSize(
            width: max(1, scrollView.contentSize.width - textView.textContainerInset.width * 2),
            height: CGFloat.greatestFiniteMagnitude
        )
    }

    private func resetHorizontalScroll(in scrollView: NSScrollView) {
        var origin = scrollView.contentView.bounds.origin
        guard origin.x != 0 else { return }
        origin.x = 0
        scrollView.contentView.scroll(to: origin)
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }

    private func clamped(_ range: NSRange, to text: String) -> NSRange {
        let length = (text as NSString).length
        let location = min(range.location, length)
        return NSRange(location: location, length: min(range.length, length - location))
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: WrappingMarkdownTextView
        var isUpdatingFromSwiftUI = false

        init(_ parent: WrappingMarkdownTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard !isUpdatingFromSwiftUI,
                  let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
            parent.onTextChange()
        }
    }
}

private enum EditorPalette {
    static let body = NSColor(calibratedRed: 58.0 / 255.0, green: 58.0 / 255.0, blue: 58.0 / 255.0, alpha: 1)
}

private final class HorizontalLockedTextView: NSTextView {
    override func scrollRangeToVisible(_ range: NSRange) {
        super.scrollRangeToVisible(range)
        resetHorizontalScroll()
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        DispatchQueue.main.async { [weak self] in
            self?.resetHorizontalScroll()
        }
    }

    private func resetHorizontalScroll() {
        guard let scrollView = enclosingScrollView else { return }
        var origin = scrollView.contentView.bounds.origin
        guard origin.x != 0 else { return }
        origin.x = 0
        scrollView.contentView.scroll(to: origin)
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }
}
