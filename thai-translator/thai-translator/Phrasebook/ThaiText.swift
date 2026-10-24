//
//  ThaiText.swift
//  thai-translator
//

import Foundation

nonisolated extension AttributedString {
    /// Thai text tagged with the `th` language so VoiceOver reads it with a Thai voice.
    static func thai(_ text: String) -> AttributedString {
        var attributed = AttributedString(text)
        attributed.languageIdentifier = "th"
        return attributed
    }
}
