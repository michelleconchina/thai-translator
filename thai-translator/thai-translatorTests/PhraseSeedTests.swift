//
//  PhraseSeedTests.swift
//  thai-translatorTests
//

import Foundation
import Testing
@testable import thai_translator

struct PhraseSeedTests {
    private let phrases: [Phrase]

    init() throws {
        phrases = try PhraseLoader().load()
    }

    @Test func seedLoadsFromAppBundle() {
        #expect(!phrases.isEmpty)
    }

    @Test(arguments: PhraseCategory.allCases)
    func everyCategoryHasAtLeastFivePhrases(_ category: PhraseCategory) {
        #expect(phrases.filter { $0.category == category }.count >= 5)
    }

    @Test func phraseIDsAreUnique() {
        let ids = phrases.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func noFieldIsEmpty() {
        for phrase in phrases {
            #expect(!phrase.id.isEmpty, "\(phrase.id)")
            #expect(!phrase.english.isEmpty, "\(phrase.id)")
            #expect(!phrase.thai.isEmpty, "\(phrase.id)")
            #expect(!phrase.romanized.isEmpty, "\(phrase.id)")
        }
    }

    @Test func thaiFieldsUseThaiScript() {
        let thaiBlock: ClosedRange<UInt32> = 0x0E00...0x0E7F
        for phrase in phrases {
            let usesThai = phrase.thai.unicodeScalars.contains { thaiBlock.contains($0.value) }
            #expect(usesThai, "\(phrase.id)")
        }
    }

    @Test func thaiFieldsHaveNoBakedInParticle() {
        for phrase in phrases {
            let hasParticle = PoliteParticle.allCases.contains { phrase.thai.hasSuffix($0.thai) }
            #expect(!hasParticle, "\(phrase.id)")
        }
    }

    @Test func seedIncludesNotSpicyAndAllergyPhrases() {
        let ids = Set(phrases.map(\.id))
        #expect(ids.isSuperset(of: ["food-not-spicy", "food-allergy-peanuts", "food-allergy-seafood"]))
    }

    @Test func missingResourceThrows() {
        #expect(throws: PhraseLoaderError.missingResource("does-not-exist.json")) {
            try PhraseLoader(resourceName: "does-not-exist").load()
        }
    }
}
