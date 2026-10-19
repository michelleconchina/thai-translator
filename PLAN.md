# Thai Translation App — Project Plan

Offline-first EN ↔ TH translator for the Thailand trip. Built with **tara** as the first real dogfood project.

## Stack

| Area | Choice |
|---|---|
| Platform | iOS native, SwiftUI |
| Min iOS | 17.4+ (Translation framework) |
| Translation | Apple Translation framework (offline models) |
| OCR | Vision `VNRecognizeTextRequest` (`th-TH`) |
| Live camera | VisionKit `DataScannerViewController` |
| Speech in | Speech framework (`th-TH`, `en-US`) |
| Speech out | `AVSpeechSynthesizer` |
| Storage | SwiftData (favorites, history) |

**Rule:** Everything core must work in airplane mode.

## Scope

**MVP (must ship before the trip)**
1. Phrasebook and show card
2. Offline text translation
3. Snap-and-translate (photo → OCR → translate)

**V2 (if time allows)**

4. Voice mode
5. Live camera overlay
6. THB ↔ PHP converter

## Features and Tasks

### F1 — Phrasebook and Show Card
- [ ] Phrase model (EN, TH, romanized, category)
- [ ] JSON seed: greetings, prices/haggling, directions, taxi, food ("not spicy", allergies), emergency
- [ ] Category list and search
- [ ] Favorites (SwiftData)
- [ ] Show card: full-screen, large Thai text, landscape support, screen stays awake

### F2 — Offline Text Translation
- [ ] Text input with EN ↔ TH swap
- [ ] Translation framework integration (`translationTask`)
- [ ] Model download prompt and status screen
- [ ] Offline/no-model error states
- [ ] Save a translation to favorites, or send it to the show card

### F3 — Snap-and-Translate
- [ ] Camera capture and photo library picker
- [ ] Vision OCR with `th-TH`; verify `supportedRecognitionLanguages()` on device first
- [ ] Line-by-line translated results
- [ ] Test on real Thai menu and sign photos (spacing and stylized fonts are weak spots)

### F4 — Voice (V2)
- [ ] Speech-to-text, then translate, then TTS
- [ ] Conversation mode (two-sided, toggle language)

### F5 — Live Camera Overlay (V2)
- [ ] `DataScannerViewController` text recognition
- [ ] Overlay translated text on detected regions

## iOS Checklist
- [ ] Info.plist: `NSCameraUsageDescription`, `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`, `NSPhotoLibraryUsageDescription`
- [ ] Test on a real device (the simulator can't fully test camera, Vision, or speech)
- [ ] Offline test of every feature in airplane mode

## tara Workflow

| Phase | Action |
|---|---|
| Setup | Create the Xcode project, then run tara init in the repo root and check that it detects SwiftUI/iOS correctly |
| Plan | Use tara's plan/spec command per feature (F1–F5), with one feature per branch |
| Build | Loop through implement, test, review, and commit/PR |
| Release | Install via TestFlight or directly on device |

**Task sizing:** Keep tasks small, like the checkbox items above. Don't hand tara "build phrasebook" as one task.

## Pre-Trip Checklist
- [ ] Download TH and EN translation models on Wi-Fi
- [ ] Download Thai speech and on-device dictation, if using voice
- [ ] Full airplane-mode run-through
- [ ] Favorite the top 20 phrases for quick access

## tara Gaps Log

Track these in `TARA_NOTES.md` while building:
- Anything you had to explain manually
- Commands that felt too generic
- Missing iOS-specific steps

This becomes the tara backlog after the trip.
