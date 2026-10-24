<!-- tara-schema: 1 -->
# Learnings
<!-- One line per lesson: - YYYY-MM-DD · [area] · lesson · evidence: <test / command / commit> -->
<!-- Added by /tara:test and /tara:learn after verification. No entry without evidence. Prune with /tara:learn --prune. -->
- 2026-10-24 · [testing] · thai-translatorTests is hosted by the app (TEST_HOST set), so Bundle.main is the app bundle in tests, and .json files placed in thai-translator/ are bundled automatically (synchronized group); load resources with Bundle.main, no Bundle(for:) needed · evidence: PhraseSeedTests/seedLoadsFromAppBundle passed
- 2026-10-24 · [ios] · App target defaults to MainActor isolation (SWIFT_DEFAULT_ACTOR_ISOLATION) but thai-translatorTests does not; mark model/value types nonisolated so tests and background loading can use them and their Codable conformance · evidence: project.pbxproj build settings; PhraseTests 5 passed with nonisolated Phrase
- 2026-10-24 · [build] · Remove Xcode targets via the TARGETS list, not by deleting their folder: a leftover target stays in the scheme and the test command fails with "bundle couldn't be loaded because its executable couldn't be located" · evidence: test command TEST FAILED, then TEST SUCCEEDED after thai-translatorUITests was removed in Xcode
