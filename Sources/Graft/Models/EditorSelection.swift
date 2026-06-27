import Foundation

struct EditorSelection: Equatable {
    var range: NSRange
    var line: Int
    var selectedText: String

    init(range: NSRange = NSRange(location: 0, length: 0), in text: String = "") {
        let nsText = text as NSString
        let safeRange = range.clamped(toUTF16Length: nsText.length)
        self.range = safeRange
        self.selectedText = nsText.substring(with: safeRange)

        let prefix = nsText.substring(with: NSRange(location: 0, length: safeRange.location))
        self.line = max(1, prefix.components(separatedBy: .newlines).count)
    }

    static func == (lhs: EditorSelection, rhs: EditorSelection) -> Bool {
        lhs.range.location == rhs.range.location
            && lhs.range.length == rhs.range.length
            && lhs.line == rhs.line
            && lhs.selectedText == rhs.selectedText
    }
}

extension NSRange {
    func clamped(toUTF16Length length: Int) -> NSRange {
        let safeLocation = max(0, min(location, length))
        let availableLength = max(0, length - safeLocation)
        let safeLength = max(0, min(self.length, availableLength))
        return NSRange(location: safeLocation, length: safeLength)
    }
}
