//
//  PhraseTests.swift
//  thai-translatorTests
//

import Foundation
import Testing
@testable import thai_translator

struct PhraseTests {
    private func decode(_ json: String) throws -> Phrase {
        try JSONDecoder().decode(Phrase.self, from: Data(json.utf8))
    }

    private let thankYou = Phrase(
        id: "greetings-thank-you",
        english: "Thank you",
        thai: "ขอบคุณ",
        romanized: "khop khun",
        category: .greetings,
        usesPoliteParticle: true
    )

    @Test func decodesPhraseFromJSON() throws {
        let phrase = try decode("""
        {
          "id": "food-not-spicy",
          "english": "Not spicy, please",
          "thai": "ไม่เผ็ด",
          "romanized": "mai phet",
          "category": "food",
          "usesPoliteParticle": true
        }
        """)

        #expect(phrase.id == "food-not-spicy")
        #expect(phrase.english == "Not spicy, please")
        #expect(phrase.thai == "ไม่เผ็ด")
        #expect(phrase.romanized == "mai phet")
        #expect(phrase.category == .food)
        #expect(phrase.usesPoliteParticle)
    }

    @Test func unknownCategoryFailsToDecode() {
        #expect(throws: DecodingError.self) {
            try decode("""
            {
              "id": "x",
              "english": "x",
              "thai": "x",
              "romanized": "x",
              "category": "shopping",
              "usesPoliteParticle": false
            }
            """)
        }
    }

    @Test(arguments: PoliteParticle.allCases)
    func appendsParticleWhenPhraseUsesIt(_ particle: PoliteParticle) {
        #expect(thankYou.thai(with: particle) == "ขอบคุณ" + particle.thai)
        #expect(thankYou.romanized(with: particle) == "khop khun " + particle.romanized)
    }

    @Test(arguments: PoliteParticle.allCases)
    func leavesPhraseUnchangedWhenParticleNotUsed(_ particle: PoliteParticle) {
        let help = Phrase(
            id: "emergency-help",
            english: "Help!",
            thai: "ช่วยด้วย",
            romanized: "chuay duay",
            category: .emergency,
            usesPoliteParticle: false
        )

        #expect(help.thai(with: particle) == "ช่วยด้วย")
        #expect(help.romanized(with: particle) == "chuay duay")
    }

    @Test func particlesMatchSpeaker() {
        #expect(PoliteParticle.khrap.thai == "ครับ")
        #expect(PoliteParticle.kha.thai == "ค่ะ")
    }
}
