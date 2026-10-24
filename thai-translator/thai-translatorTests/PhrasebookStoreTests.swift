//
//  PhrasebookStoreTests.swift
//  thai-translatorTests
//

import Foundation
import Testing
@testable import thai_translator

@MainActor
struct PhrasebookStoreTests {
    private struct LoadFailed: Error {}

    private nonisolated static let sample: [Phrase] = [
        Phrase(id: "food-not-spicy", english: "Not spicy, please", thai: "ไม่เผ็ด", romanized: "mai phet", category: .food, usesPoliteParticle: true),
        Phrase(id: "greetings-hello", english: "Hello", thai: "สวัสดี", romanized: "sawatdee", category: .greetings, usesPoliteParticle: true),
        Phrase(id: "food-a-little-spicy", english: "A little spicy", thai: "เผ็ดนิดหน่อย", romanized: "phet nit noi", category: .food, usesPoliteParticle: true),
    ]

    private func loadedStore() async -> PhrasebookStore {
        let store = PhrasebookStore(load: { Self.sample })
        await store.load()
        return store
    }

    @Test func startsInLoadingState() {
        let store = PhrasebookStore(load: { Self.sample })
        #expect(store.state == .loading)
    }

    @Test func loadSucceedsIntoLoadedState() async {
        let store = await loadedStore()
        #expect(store.state == .loaded(Self.sample))
    }

    @Test func loadFailureIntoFailedState() async {
        let store = PhrasebookStore(load: { throw LoadFailed() })
        await store.load()
        guard case .failed(let message) = store.state else {
            Issue.record("Expected failed state, got \(store.state)")
            return
        }
        #expect(!message.isEmpty)
    }

    @Test func phrasesInCategoryAreFilteredAndKeepSeedOrder() async {
        let store = await loadedStore()
        #expect(store.phrases(in: .food).map(\.id) == ["food-not-spicy", "food-a-little-spicy"])
        #expect(store.phrases(in: .taxi).isEmpty)
    }

    @Test func countInCategoryMatchesPhrases() async {
        let store = await loadedStore()
        #expect(store.count(in: .food) == 2)
        #expect(store.count(in: .greetings) == 1)
        #expect(store.count(in: .emergency) == 0)
    }

    @Test func searchMatchesEnglish() async {
        let store = await loadedStore()
        #expect(store.searchResults(for: "spicy").map(\.id) == ["food-not-spicy", "food-a-little-spicy"])
    }

    @Test func searchMatchesRomanizedIgnoringCase() async {
        let store = await loadedStore()
        #expect(store.searchResults(for: "SAWATDEE").map(\.id) == ["greetings-hello"])
    }

    @Test func searchMatchesThai() async {
        let store = await loadedStore()
        #expect(store.searchResults(for: "เผ็ด").map(\.id) == ["food-not-spicy", "food-a-little-spicy"])
    }

    @Test(arguments: ["", "   ", "\n"])
    func blankSearchReturnsNoResults(_ query: String) async {
        let store = await loadedStore()
        #expect(store.searchResults(for: query).isEmpty)
    }

    @Test func searchWithNoMatchReturnsEmpty() async {
        let store = await loadedStore()
        #expect(store.searchResults(for: "taxi").isEmpty)
    }

    private actor CallCounter {
        private(set) var count = 0
        func increment() { count += 1 }
    }

    @Test func loadDoesNothingWhenAlreadyLoaded() async {
        let counter = CallCounter()
        let store = PhrasebookStore(load: {
            await counter.increment()
            return Self.sample
        })
        await store.load()
        await store.load()
        #expect(await counter.count == 1)
        #expect(store.state == .loaded(Self.sample))
    }

    @Test func reloadAfterFailureLoadsAgain() async {
        let counter = CallCounter()
        let store = PhrasebookStore(load: {
            await counter.increment()
            if await counter.count == 1 { throw LoadFailed() }
            return Self.sample
        })
        await store.load()
        guard case .failed = store.state else {
            Issue.record("Expected failed state, got \(store.state)")
            return
        }
        await store.reload()
        #expect(store.state == .loaded(Self.sample))
        #expect(await counter.count == 2)
    }

    @Test func overlappingReloadsRunLoaderOnce() async {
        let counter = CallCounter()
        let store = PhrasebookStore(load: {
            await counter.increment()
            try await Task.sleep(for: .milliseconds(100))
            return Self.sample
        })
        async let first: Void = store.reload()
        async let second: Void = store.reload()
        _ = await (first, second)
        #expect(await counter.count == 1)
        #expect(store.state == .loaded(Self.sample))
    }

    @Test(arguments: [("", false), ("   ", false), ("\n", false), ("spicy", true), (" เผ็ด ", true)])
    func isSearchingIgnoresSurroundingWhitespace(_ query: String, _ expected: Bool) {
        let store = PhrasebookStore(load: { Self.sample })
        #expect(store.isSearching(query) == expected)
    }

    @Test func loadInBackgroundReturnsSeed() async throws {
        let background = try await PhraseLoader().loadInBackground()
        let direct = try PhraseLoader().load()
        #expect(background == direct)
        #expect(!background.isEmpty)
    }
}
