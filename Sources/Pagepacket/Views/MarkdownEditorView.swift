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
                        .foregroundStyle(PagepacketTheme.ink)
                    Text(workspace.selectedFile?.relativePath ?? "")
                        .font(.caption)
                        .foregroundStyle(PagepacketTheme.muted)
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
            .background(PagepacketTheme.surfaceSoft)

            WrappingMarkdownTextView(text: $workspace.editorText, fontSize: workspace.editorFontSize)
                .background(PagepacketTheme.canvas)
                .onChange(of: workspace.editorText) { _, _ in
                    guard workspace.autosaveEnabled, workspace.isDirty else { return }
                    workspace.saveCurrentDocument()
                }
        }
    }
}

private struct WrappingMarkdownTextView: NSViewRepresentable {
    @Binding var text: String
    let fontSize: Double

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeNSView(context: Context) -> MarkdownTextScrollView {
        let scrollView = MarkdownTextScrollView()
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.contentView = NoHorizontalScrollClipView()

        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.string = text
        textView.setSelectedRange(NSRange(location: 0, length: 0))
        textView.isRichText = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.drawsBackground = true
        textView.backgroundColor = PagepacketTheme.nsCanvas
        textView.textColor = PagepacketTheme.nsBody
        textView.insertionPointColor = PagepacketTheme.nsInk
        textView.selectedTextAttributes = [
            .backgroundColor: PagepacketTheme.nsSelection,
            .foregroundColor: PagepacketTheme.nsInk
        ]
        textView.font = NSFont.monospacedSystemFont(ofSize: CGFloat(fontSize), weight: .regular)
        textView.textContainerInset = NSSize(width: 18, height: 18)
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainer?.lineBreakMode = .byWordWrapping
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: scrollView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.minSize = .zero
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.autoresizingMask = [.width]
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false

        scrollView.documentView = textView
        scrollView.markdownTextView = textView
        context.coordinator.textView = textView
        DispatchQueue.main.async {
            textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
            scrollView.resetHorizontalOffset()
        }
        return scrollView
    }

    func updateNSView(_ scrollView: MarkdownTextScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        if textView.string != text {
            textView.string = text
            textView.setSelectedRange(NSRange(location: 0, length: 0))
            DispatchQueue.main.async {
                textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
                scrollView.resetHorizontalOffset()
            }
        }
        textView.font = NSFont.monospacedSystemFont(ofSize: CGFloat(fontSize), weight: .regular)
        textView.backgroundColor = PagepacketTheme.nsCanvas
        textView.textColor = PagepacketTheme.nsBody
        textView.insertionPointColor = PagepacketTheme.nsInk
        textView.textContainer?.lineBreakMode = .byWordWrapping
        textView.textContainer?.containerSize = NSSize(width: scrollView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        scrollView.resetHorizontalOffset()
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding private var text: String
        weak var textView: NSTextView?

        init(text: Binding<String>) {
            _text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text = textView.string
        }
    }
}

private final class MarkdownTextScrollView: NSScrollView {
    weak var markdownTextView: NSTextView?

    override func layout() {
        super.layout()
        guard let textView = markdownTextView else { return }
        let width = max(contentSize.width, 1)
        textView.textContainer?.containerSize = NSSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.setFrameOrigin(.zero)
        textView.setFrameSize(NSSize(width: width, height: max(textView.frame.height, contentSize.height)))
        resetHorizontalOffset()
    }

    func resetHorizontalOffset() {
        var bounds = contentView.bounds
        bounds.origin.x = 0
        contentView.bounds = bounds
        reflectScrolledClipView(contentView)
    }
}

private final class NoHorizontalScrollClipView: NSClipView {
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        var bounds = super.constrainBoundsRect(proposedBounds)
        bounds.origin.x = 0
        return bounds
    }
}
