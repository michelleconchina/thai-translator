# F1 phrasebook: Phrase model and JSON seed
Status: in-progress
## Context
- `PLAN.md` (repo root) F1 asks for a Phrase model (EN, TH, romanized, category) and a JSON seed covering greetings, prices/haggling, directions, taxi, food ("not spicy", allergies), and emergency. Favorites (SwiftData), list/search, and the show card are later F1 tasks, not this plan.
- `thai-translator/ThaiTranslatorApp.swift` and `thai-translator/ContentView.swift` are the only source files; there is no model layer, feature folder, or existing feature to copy.
- `thai-translator.xcodeproj/project.pbxproj` uses a `PBXFileSystemSynchronizedRootGroup` for `thai-translator/`, so new `.swift` and `.json` files in that folder join the app target (and its bundle) without pbxproj edits. Build settings: `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, deployment target 26.2.
- `docs/tara-knowledge/project.md`: test command is `unknown` and there is no test target, so this plan has to add one before any phase can carry tests.
- Learnings applied: none relevant (`learnings.md` is empty).
## Phases
- [ ] Phase 1 — Add a Swift Testing unit test target and record the test command
  - Files: new target `thai-translatorTests` with `thai-translatorTests/thai_translatorTests.swift` (created **by you in Xcode**: File → New → Target → Unit Testing Bundle, Testing System: Swift Testing, target to be tested: thai-translator); `thai-translator.xcodeproj/project.pbxproj` (changed by Xcode); `docs/tara-knowledge/project.md` test line
  - Acceptance: `xcodebuild -project thai-translator.xcodeproj -scheme thai-translator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test` succeeds with the template test passing; `project.md` `test:` line set to that command.
  - Blocked: 2026-10-19 · `xcodebuild -list -project thai-translator.xcodeproj` · only target is `thai-translator`; `thai-translatorTests` not created in Xcode yet
- [ ] Phase 2 — Phrase model with categories and polite particle
  - Files: create `thai-translator/Phrasebook/Phrase.swift` (`struct Phrase: Codable, Identifiable, Hashable` with `id`, `english`, `thai`, `romanized`, `category`, `usesPoliteParticle`; `enum PhraseCategory: String, Codable, CaseIterable` with `greetings`, `prices`, `directions`, `taxi`, `food`, `emergency` and a display title; `enum PoliteParticle` (`khrap` ครับ / `kha` ค่ะ) with `Phrase.thai(with:)` and `romanized(with:)`); create `thai-translatorTests/PhraseTests.swift`
  - Acceptance: test command passes, including new tests `decodesPhraseFromJSON`, `unknownCategoryFailsToDecode`, `appendsParticleWhenPhraseUsesIt` (parameterized over both particles), `leavesPhraseUnchangedWhenParticleNotUsed`.
- [ ] Phase 3 — Bundled JSON seed and loader
  - Files: create `thai-translator/Phrasebook/phrases.json` (~8 phrases per category, 6 categories, stable string ids like `food-not-spicy`); create `thai-translator/Phrasebook/PhraseLoader.swift` (`struct PhraseLoader` that decodes `[Phrase]` from a `Bundle` + resource name, throwing a typed `PhraseLoaderError` for missing file or bad JSON; no force unwraps); create `thai-translatorTests/PhraseSeedTests.swift`
  - Acceptance: test command passes, including new tests `seedLoadsFromAppBundle`, `everyCategoryHasAtLeastFivePhrases`, `phraseIDsAreUnique`, `noFieldIsEmpty`, `thaiFieldsUseThaiScript` (every `thai` contains U+0E00–U+0E7F), `thaiFieldsHaveNoBakedInParticle` (no `thai` ends in ครับ/ค่ะ), `seedIncludesNotSpicyAndAllergyPhrases`, and `missingResourceThrows`; build-ios still succeeds.
## Risks
- Phase 1 needs you in Xcode: `/tara:execute` can't create a test target safely (hand-writing a new target into `project.pbxproj` is error-prone). Execute will stop at Phase 1 until the target exists.
- Thai text accuracy: the seed's Thai and romanization will be written by Claude; tests can check script and structure but not meaning or naturalness. Have a Thai speaker skim it, or check key phrases (allergies, emergency) against a trusted phrasebook before the trip.
- Allergy and emergency phrases are safety-relevant: a wrong translation could matter. They should be short and literal, and marked for your review in the plan's done notes.
- Loading from `Bundle.main` in tests: with a hosted unit test target the app bundle is `Bundle.main`; if Xcode creates the target without a host app, the seed test must use `Bundle(for:)`/a type in the app module instead. Check after Phase 1.
## Decisions
- New folder `thai-translator/Phrasebook/`: first feature folder (feature-first layout). Needs your OK since `project.md` currently says flat layout; on approval, Phase 2 updates the Architecture line.
- Swift Testing (`import Testing`, `@Test`, `#expect`) rather than XCTest: new code, iOS 26 toolchain, and parameterized tests fit the particle cases.
- Polite particle (ครับ for male speakers, ค่ะ for female speakers) is not stored in the Thai text; phrases flag `usesPoliteParticle` and the app appends the one you pick. The setting UI that picks it is a later task; until then callers pass the particle explicitly. Confirm this, or say which particle to bake in instead.
- Romanization: simple, readable, no tone marks (e.g. "mai phet"), not RTGS or IPA. Confirm, or ask for tone marks.
- Plain `Codable` structs now, no SwiftData: the seed is read-only. Favorites (SwiftData) will reference phrases by their stable `id` in a later plan.
- Out of scope: category list and search UI, favorites, show card, deployment target (26.2 vs PLAN.md's 17.4).
