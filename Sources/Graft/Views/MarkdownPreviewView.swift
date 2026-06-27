import SwiftUI
import AppKit

struct MarkdownPreviewView: View {
    @EnvironmentObject private var workspace: WorkspaceStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(workspace.renderedBlocks.enumerated()), id: \.offset) { _, block in
                    blockView(block)
                }
            }
            .frame(maxWidth: 760, alignment: .leading)
            .padding(32)
        }
        .background(GraftTheme.surfaceSoft)
        .foregroundStyle(GraftTheme.body)
    }

    @ViewBuilder
    private func blockView(_ block: MarkdownBlock) -> some View {
        switch block {
        case let .heading(level, text):
            Text(text)
                .font(.system(size: headingSize(level), weight: .medium, design: .rounded))
                .foregroundStyle(GraftTheme.ink)
                .padding(.top, level == 1 ? 8 : 4)
        case let .paragraph(text):
            MarkdownInlineText(text)
                .font(.body)
                .lineSpacing(4)
                .foregroundStyle(GraftTheme.body)
        case let .quote(text):
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(GraftTheme.lavender)
                    .frame(width: 4)
                MarkdownInlineText(text)
                    .foregroundStyle(GraftTheme.body)
            }
            .padding(.vertical, 4)
        case let .unorderedItem(depth, text):
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Circle()
                    .fill(GraftTheme.teal)
                    .frame(width: 6, height: 6)
                    .padding(.top, 2)
                MarkdownInlineText(text)
            }
            .padding(.leading, CGFloat(depth) * 18)
        case let .orderedItem(number, depth, text):
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("\(number).")
                    .font(.callout.monospacedDigit().weight(.semibold))
                    .foregroundStyle(GraftTheme.ochre)
                    .frame(width: 28, alignment: .trailing)
                MarkdownInlineText(text)
            }
            .padding(.leading, CGFloat(depth) * 18)
        case let .task(done, depth, text):
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Image(systemName: done ? "checkmark.square.fill" : "square")
                    .foregroundStyle(done ? GraftTheme.teal : GraftTheme.muted)
                MarkdownInlineText(text)
            }
            .padding(.leading, CGFloat(depth) * 18)
        case let .code(language, text):
            VStack(alignment: .leading, spacing: 8) {
                if let language {
                    Text(language.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(GraftTheme.muted)
                }
                ScrollView(.horizontal) {
                    Text(text)
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundStyle(GraftTheme.ink)
                        .lineSpacing(3)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .background(Color.white.opacity(0.45))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .graftCard()
        case let .table(headers, rows):
            ScrollView(.horizontal) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(Array(headers.enumerated()), id: \.offset) { _, header in
                            Text(header)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(GraftTheme.ink)
                                .frame(minWidth: 150, alignment: .leading)
                                .padding(8)
                                .background(GraftTheme.ochre.opacity(0.28))
                        }
                    }
                    ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                        HStack(spacing: 0) {
                            ForEach(Array(normalized(row, width: headers.count).enumerated()), id: \.offset) { _, cell in
                                MarkdownInlineText(cell)
                                    .font(.callout)
                                    .frame(minWidth: 150, alignment: .leading)
                                    .padding(8)
                                    .background(rowIndex.isMultiple(of: 2) ? Color.black.opacity(0.025) : Color.clear)
                            }
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.black.opacity(0.08), lineWidth: 1)
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
                    .frame(maxHeight: 420)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Label {
                        Text(alt.isEmpty ? "No alt text" : alt)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(GraftTheme.ink)
                    } icon: {
                        Image(systemName: "text.below.photo")
                            .foregroundStyle(GraftTheme.teal)
                    }
                    Text(path)
                        .font(.caption2)
                        .foregroundStyle(GraftTheme.muted)
                        .textSelection(.enabled)
                }
            }
            .graftCard()
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Label {
                    Text(alt.isEmpty ? "Missing image" : alt)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(GraftTheme.ink)
                } icon: {
                    Image(systemName: "photo")
                        .foregroundStyle(GraftTheme.pink)
                }
                Text(path)
                    .font(.caption2.monospaced())
                    .foregroundStyle(GraftTheme.muted)
                    .textSelection(.enabled)
            }
            .graftCard()
        }
    }

    private func image(for path: String) -> NSImage? {
        guard let file = workspace.selectedFile else { return nil }
        let url = file.url.deletingLastPathComponent().appendingPathComponent(path).standardizedFileURL
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
}

private struct MarkdownInlineText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        markdownText
            .tint(GraftTheme.teal)
    }

    private var markdownText: Text {
        if var attributed = try? AttributedString(markdown: text) {
            for run in attributed.runs {
                if run.link != nil {
                    attributed[run.range].foregroundColor = GraftTheme.teal
                    attributed[run.range].underlineStyle = .single
                }
                if run.inlinePresentationIntent?.contains(.code) == true {
                    attributed[run.range].foregroundColor = GraftTheme.teal
                    attributed[run.range].backgroundColor = GraftTheme.mint.opacity(0.24)
                    attributed[run.range].font = .system(.body, design: .monospaced)
                }
            }
            return Text(attributed)
                .foregroundColor(GraftTheme.body)
        }
        return Text(text)
            .foregroundColor(GraftTheme.body)
    }
}
