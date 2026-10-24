<!-- tara-schema: 1 -->
# Project
- Name: thai-translator
- Stack: ios
- Secondary:
- Languages: Swift
- State management: none detected (no Observation, Combine, or TCA usage)
- UI framework: SwiftUI (`@main` App in `thai-translator/ThaiTranslatorApp.swift`; generated launch screen)
- Architecture: feature-first: `thai-translator/<Feature>/` (first: `thai-translator/Phrasebook/`), app entry `thai-translator/ThaiTranslatorApp.swift`; tests in `thai-translatorTests/` (Swift Testing)
- Flavors / schemes / environments: scheme `thai-translator` (not a shared scheme yet, verify with `xcodebuild -list`); simulator `iPhone 17 Pro`; no flavors or env files
- Firebase / backend services: none detected

# Commands
- run: `xcodebuild -project thai-translator.xcodeproj -scheme thai-translator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- test: `xcodebuild -project thai-translator.xcodeproj -scheme thai-translator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test`
- analyze/lint: —
- format: —
- build-android: —
- build-ios: `xcodebuild -project thai-translator.xcodeproj -scheme thai-translator -destination 'generic/platform=iOS Simulator' build`

# Conventions
- (none yet: no lint, format, codegen, DI, or test config in the repo)

# Protected files
- (none)
