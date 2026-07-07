import SwiftUI
import AppKit

struct MarkdownPreviewView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(workspace.renderedBlocks) { block in
                        blockView(block)
                    }
                }
                .frame(width: contentWidth(for: proxy.size.width), alignment: .leading)
                .padding(32)
                .foregroundStyle(PagepacketTheme.body)
            }
            .background(PagepacketTheme.surfaceSoft)
        }
    }

    @ViewBuilder
    private func blockView(_ block: MarkdownBlock) -> some View {
        switch block {
        case let .heading(level, text):
            Text(text)
                .font(.system(size: headingSize(level), weight: .medium, design: .rounded))
                .foregroundStyle(PagepacketTheme.ink)
                .padding(.top, level == 1 ? 8 : 4)
        case let .paragraph(text):
            MarkdownInlineText(text)
                .font(.body)
                .foregroundStyle(PagepacketTheme.body)
                .lineSpacing(4)
        case let .quote(text):
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(PagepacketTheme.lavender)
                    .frame(width: 4)
                MarkdownInlineText(text)
                    .foregroundStyle(PagepacketTheme.muted)
            }
            .padding(.vertical, 4)
        case let .unorderedItem(text):
            Label {
                MarkdownInlineText(text)
                    .foregroundStyle(PagepacketTheme.body)
            } icon: {
                Circle()
                    .fill(PagepacketTheme.teal)
                    .frame(width: 6, height: 6)
            }
        case let .orderedItem(text):
            HStack(alignment: .top) {
                Text("1.")
                    .foregroundStyle(PagepacketTheme.ochre)
                MarkdownInlineText(text)
                    .foregroundStyle(PagepacketTheme.body)
            }
        case let .task(done, text):
            HStack {
                Image(systemName: done ? "checkmark.square.fill" : "square")
                    .foregroundStyle(done ? PagepacketTheme.teal : PagepacketTheme.muted)
                MarkdownInlineText(text)
                    .foregroundStyle(PagepacketTheme.body)
            }
        case let .code(language, text):
            VStack(alignment: .leading, spacing: 8) {
                if let language {
                    Text(language.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PagepacketTheme.muted)
                }
                Text(text)
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(PagepacketTheme.ink)
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .pagepacketCard()
        case let .table(headers, rows):
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(Array(headers.enumerated()), id: \.offset) { _, header in
                        Text(header)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(PagepacketTheme.ink)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(PagepacketTheme.ochre.opacity(0.28))
                    }
                }
                ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                    HStack(spacing: 0) {
                        ForEach(Array(normalized(row, width: headers.count).enumerated()), id: \.offset) { _, cell in
                            MarkdownInlineText(cell)
                                .font(.callout)
                                .foregroundStyle(PagepacketTheme.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                                .background(rowIndex.isMultiple(of: 2) ? Color.black.opacity(0.025) : Color.clear)
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(PagepacketTheme.divider.opacity(0.75), lineWidth: 1)
            }
            .padding(.vertical, 4)
        case let .image(alt, path):
            imageView(alt: alt, path: path)
        case .horizontalRule:
            Rectangle()
                .fill(.black.opacity(0.12))
                .frame(height: 1)
                .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private func imageView(alt: String, path: String) -> some View {
        if let image = image(for: path) {
            VStack(alignment: .leading, spacing: 8) {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                HStack {
                    Label(alt.isEmpty ? "Image" : alt, systemImage: "text.below.photo")
                    Spacer()
                    Text(path)
                        .lineLimit(1)
                }
                .font(.caption)
                .foregroundStyle(PagepacketTheme.muted)
            }
            .pagepacketCard()
        } else {
            Label("Missing image: \(path)", systemImage: "photo")
                .foregroundStyle(PagepacketTheme.pink)
                .pagepacketCard()
        }
    }

    private func image(for path: String) -> NSImage? {
        guard let file = workspace.selectedFile else { return nil }
        let url = file.url.deletingLastPathComponent().appendingPathComponent(path)
        return NSImage(contentsOf: url)
    }

    private func headingSize(_ level: Int) -> CGFloat {
        switch level {
        case 1: 38
        case 2: 30
        case 3: 24
        default: 19
        }
    }

    private func normalized(_ row: [String], width: Int) -> [String] {
        if row.count >= width {
            return Array(row.prefix(width))
        }
        return row + Array(repeating: "", count: width - row.count)
    }

    private func contentWidth(for containerWidth: CGFloat) -> CGFloat {
        min(max(containerWidth - 64, 260), 760)
    }
}

private struct MarkdownInlineText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Group {
            if let attributed = try? AttributedString(markdown: text) {
                Text(attributed)
            } else {
                Text(text)
            }
        }
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
    }
}
