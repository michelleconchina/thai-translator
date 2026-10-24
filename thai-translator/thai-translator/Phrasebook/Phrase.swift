//
//  Phrase.swift
//  thai-translator
//

import Foundation

/// A phrasebook entry. `thai` and `romanized` never include the polite particle;
/// use `thai(with:)` / `romanized(with:)` to get the text to show or speak.
nonisolated struct Phrase: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let english: String
    let thai: String
    let romanized: String
    let category: PhraseCategory
    let usesPoliteParticle: Bool

    func thai(with particle: PoliteParticle) -> String {
        usesPoliteParticle ? thai + particle.thai : thai
    }

    func romanized(with particle: PoliteParticle) -> String {
        usesPoliteParticle ? "\(romanized) \(particle.romanized)" : romanized
    }
}

nonisolated enum PhraseCategory: String, Codable, CaseIterable, Sendable {
    case greetings
    case prices
    case directions
    case taxi
    case food
    case emergency

    var title: String {
        switch self {
        case .greetings: "Greetings"
        case .prices: "Prices & Haggling"
        case .directions: "Directions"
        case .taxi: "Taxi"
        case .food: "Food"
        case .emergency: "Emergency"
        }
    }
}

/// Sentence-final politeness particle, chosen by the speaker's gender.
nonisolated enum PoliteParticle: String, CaseIterable, Sendable {
    /// Used by male speakers.
    case khrap
    /// Used by female speakers.
    case kha

    var thai: String {
        switch self {
        case .khrap: "ครับ"
        case .kha: "ค่ะ"
        }
    }

    var romanized: String {
        switch self {
        case .khrap: "khrap"
        case .kha: "kha"
        }
    }
}
