//
//  PhraseListView.swift
//  thai-translator
//

import SwiftUI

struct PhraseListView: View {
    let category: PhraseCategory
    let phrases: [Phrase]
    let particle: PoliteParticle

    var body: some View {
        List(phrases) { phrase in
            PhraseRow(phrase: phrase, particle: particle)
        }
        .overlay {
            if phrases.isEmpty {
                ContentUnavailableView("No Phrases Yet", systemImage: category.systemImage)
            }
        }
        .navigationTitle(category.title)
    }
}

#Preview {
    NavigationStack {
        PhraseListView(category: .food, phrases: PhraseRow.previewPhrases, particle: .kha)
    }
}

#Preview("Empty") {
    NavigationStack {
        PhraseListView(category: .taxi, phrases: [], particle: .kha)
    }
}
