//
//  PhrasebookStore.swift
//  thai-translator
//

import Foundation
import Observation

@MainActor
@Observable
final class PhrasebookStore {
    enum State: Equatable {
        case loading
        case loaded([Phrase])
        case failed(String)
    }

    private(set) var state: State = .loading

    @ObservationIgnored
    private let loadPhrases: @Sendable () async throws -> [Phrase]

    init(load: @escaping @Sendable () async throws -> [Phrase] = { try await PhraseLoader().loadInBackground() }) {
        self.loadPhrases = load
    }

    @ObservationIgnored
    private var isLoadInFlight = false

    /// Loads the phrasebook once; does nothing if it's already loaded.
    func load() async {
        if case .loaded = state { return }
        await reload()
    }

    /// Loads the phrasebook again (e.g. after a failure). Ignored while a load is running.
    func reload() async {
        guard !isLoadInFlight else { return }
        isLoadInFlight = true
        defer { isLoadInFlight = false }

        state = .loading
        do {
            state = .loaded(try await loadPhrases())
        } catch {
            state = .failed("The phrasebook couldn't be loaded.")
        }
    }

    func phrases(in category: PhraseCategory) -> [Phrase] {
        guard case .loaded(let phrases) = state else { return [] }
        return phrases.filter { $0.category == category }
    }

    func count(in category: PhraseCategory) -> Int {
        phrases(in: category).count
    }

    /// Whether `query` should show search results instead of the category list.
    func isSearching(_ query: String) -> Bool {
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Phrases whose English, romanized, or Thai text contains `query`,
    /// ignoring case and diacritics. A blank query matches nothing.
    func searchResults(for query: String) -> [Phrase] {
        guard isSearching(query), case .loaded(let phrases) = state else { return [] }
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return phrases.filter { phrase in
            [phrase.english, phrase.romanized, phrase.thai].contains { $0.localizedStandardContains(query) }
        }
    }
}
