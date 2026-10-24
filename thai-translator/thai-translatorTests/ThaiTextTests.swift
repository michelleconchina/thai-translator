//
//  ThaiTextTests.swift
//  thai-translatorTests
//

import Foundation
import Testing
@testable import thai_translator

struct ThaiTextTests {
    @Test func thaiTextIsTaggedWithThaiLanguage() {
        let text = AttributedString.thai("ขอบคุณค่ะ")
        #expect(String(text.characters) == "ขอบคุณค่ะ")
        #expect(text.runs.allSatisfy { $0.languageIdentifier == "th" })
    }

    @Test func particlesDescribeTheirSpeaker() {
        #expect(PoliteParticle.kha.speaker == "female speaker")
        #expect(PoliteParticle.khrap.speaker == "male speaker")
    }
}
