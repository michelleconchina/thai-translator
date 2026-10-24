//
//  PhrasebookView.swift
//  thai-translator
//

import SwiftUI

struct PhrasebookView: View {
    @State private var store = PhrasebookStore()
    @State private var searchText = ""
    @AppStorage("politeParticle") private var particle: PoliteParticle = .kha

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Phrasebook")
                .navigationDestination(for: PhraseCategory.self) { category in
                    PhraseListView(category: category, phrases: store.phrases(in: category), particle: particle)
                }
                .searchable(text: $searchText, prompt: "English, Thai, or romanized")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        particleMenu
                    }
                }
        }
        .task { await store.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch store.state {
        case .loading:
            ProgressView("Loading phrases…")
        case .failed(let message):
            ContentUnavailableView {
                Label("Phrasebook Unavailable", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
                    Task { await store.reload() }
                }
            }
        case .loaded:
            if store.isSearching(searchText) {
                searchResults
            } else {
                categoryList
            }
        }
    }

    private var particleMenu: some View {
        Menu {
            Picker("Polite particle", selection: $particle) {
                ForEach(PoliteParticle.allCases, id: \.self) { option in
                    VStack {
                        Text(AttributedString.thai(option.thai))
                        Text("\(option.romanized) · \(option.speaker)")
                    }
                    .tag(option)
                }
            }
        } label: {
            Text(AttributedString.thai(particle.thai))
        }
        .accessibilityLabel("Polite particle")
        .accessibilityValue("\(particle.romanized), \(particle.speaker)")
    }

    private var categoryList: some View {
        List(PhraseCategory.allCases, id: \.self) { category in
            NavigationLink(value: category) {
                Label(category.title, systemImage: category.systemImage)
            }
            .badge(store.count(in: category))
        }
    }

    private var searchResults: some View {
        let results = store.searchResults(for: searchText)
        return List(results) { phrase in
            PhraseRow(phrase: phrase, particle: particle)
        }
        .overlay {
            if results.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
}

#Preview {
    PhrasebookView()
}
