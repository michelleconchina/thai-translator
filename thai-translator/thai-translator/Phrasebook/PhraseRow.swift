//
//  PhraseRow.swift
//  thai-translator
//

import SwiftUI

struct PhraseRow: View {
    let phrase: Phrase
    let particle: PoliteParticle

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(AttributedString.thai(phrase.thai(with: particle)))
                .font(.title2)
            Text(phrase.romanized(with: particle))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(phrase.english)
                .font(.body)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

extension PhraseRow {
    static let previewPhrases: [Phrase] = [
        Phrase(id: "food-not-spicy", english: "Not spicy, please", thai: "ไม่เผ็ด", romanized: "mai phet", category: .food, usesPoliteParticle: true),
        Phrase(id: "food-allergy-peanuts", english: "I'm allergic to peanuts", thai: "แพ้ถั่วลิสง", romanized: "phae thua lisong", category: .food, usesPoliteParticle: true),
    ]
}

#Preview {
    List(PhraseRow.previewPhrases) { PhraseRow(phrase: $0, particle: .kha) }
}
