//
//  PhraseLoader.swift
//  thai-translator
//

import Foundation

nonisolated enum PhraseLoaderError: Error, Equatable {
    case missingResource(String)
    case invalidData(String)
}

/// Loads the bundled phrasebook seed (`phrases.json`).
nonisolated struct PhraseLoader: Sendable {
    var bundle: Bundle = .main
    var resourceName: String = "phrases"

    func load() throws -> [Phrase] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw PhraseLoaderError.missingResource("\(resourceName).json")
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Phrase].self, from: data)
        } catch {
            throw PhraseLoaderError.invalidData(String(describing: error))
        }
    }

    /// Same as `load()`, but runs off the caller's actor so it never blocks the UI.
    @concurrent
    func loadInBackground() async throws -> [Phrase] {
        try load()
    }
}
