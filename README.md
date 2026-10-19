# thai-translator

Offline-first EN ↔ TH translator for iOS, built for a trip to Thailand. Everything core works in airplane mode.

- **Platform:** iOS 17.4+, SwiftUI
- **Translation:** Apple Translation framework (offline models)
- **OCR:** Vision, live camera via VisionKit
- **Speech:** Speech framework and `AVSpeechSynthesizer`
- **Storage:** SwiftData

The full plan is in [PLAN.md](PLAN.md).

## Built with tara

This is the first real dogfood project for [tara](https://github.com/michelleconchina/tara). `.claude/settings.json` enables the plugin for every Claude Code session in this repo. Gaps found while building go in [TARA_NOTES.md](TARA_NOTES.md).

## Getting started

1. Create the Xcode project in this folder (iOS 17.4 minimum).
2. Run `/tara:init` and confirm it detects SwiftUI/iOS.
3. Plan one feature per branch with `/tara:plan`, starting with F1.
