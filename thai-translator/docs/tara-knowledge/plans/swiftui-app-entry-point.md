# Replace the UIKit storyboard template with a SwiftUI App entry point
Status: done
## Context
- `thai-translator/AppDelegate.swift` holds `@main` (UIKit `UIApplicationDelegate`); `thai-translator/SceneDelegate.swift` and `thai-translator/ViewController.swift` are unmodified Xcode template code, so nothing needs porting.
- `thai-translator/Info.plist` only contains `UIApplicationSceneManifest` pointing at `SceneDelegate` and `UISceneStoryboardFile = Main`; `Base.lproj/Main.storyboard` has one empty `ViewController` scene.
- `thai-translator.xcodeproj/project.pbxproj` is `objectVersion = 77` with a `PBXFileSystemSynchronizedRootGroup` for `thai-translator/`, so adding or deleting `.swift`/storyboard files needs no pbxproj edits. The build settings (Debug and Release) still set `INFOPLIST_KEY_UIMainStoryboardFile = Main` and `INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen`.
- Build settings already have `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and `SWIFT_APPROACHABLE_CONCURRENCY = YES`; deployment target is 26.2, so `@Observable`/`NavigationStack` are available without `#available`.
- Learnings applied: none relevant (`learnings.md` is empty).
## Phases
- [x] Phase 1 — Switch the app entry point to SwiftUI
  - Files: create `thai-translator/ThaiTranslatorApp.swift` (`@main struct ThaiTranslatorApp: App` with `WindowGroup { ContentView() }`), create `thai-translator/ContentView.swift` (placeholder screen with a `#Preview`); delete `thai-translator/AppDelegate.swift`, `thai-translator/SceneDelegate.swift`, `thai-translator/ViewController.swift`, `thai-translator/Base.lproj/Main.storyboard`; remove `UIApplicationSceneManifest` from `thai-translator/Info.plist`; remove both `INFOPLIST_KEY_UIMainStoryboardFile = Main;` lines from `thai-translator.xcodeproj/project.pbxproj`
  - Acceptance: build-ios (`xcodebuild -project thai-translator.xcodeproj -scheme thai-translator -destination 'generic/platform=iOS Simulator' build`) succeeds with no new warnings; `grep -rn "import UIKit\|UIMainStoryboardFile\|SceneDelegate" thai-translator thai-translator.xcodeproj/project.pbxproj` returns nothing; the run command launches to the `ContentView` placeholder on iPhone 17 Pro.
  - Done: 2026-10-19 · evidence: analyze/lint — (not configured), test unknown (no test target); build-ios BUILD SUCCEEDED (only toolchain AppIntents metadata notice), UIKit grep empty, simulator launch screenshot shows ContentView
- [x] Phase 2 — Replace the launch storyboard with a generated launch screen and update project.md
  - Files: in `thai-translator.xcodeproj/project.pbxproj` replace both `INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen;` lines with `INFOPLIST_KEY_UILaunchScreen_Generation = YES;`; delete `thai-translator/Base.lproj/LaunchScreen.storyboard` (and the now-empty `Base.lproj/`); update `docs/tara-knowledge/project.md` UI framework line to `SwiftUI` and Architecture line to the new file layout
  - Acceptance: build-ios succeeds; `find thai-translator -name "*.storyboard"` returns nothing; app launches on the simulator without a black launch frame or a "no launch screen" letterbox; `project.md` no longer mentions storyboards.
  - Done: 2026-10-19 · evidence: analyze/lint — (not configured), test unknown (no test target); build-ios BUILD SUCCEEDED, no .storyboard files, built Info.plist has `UILaunchScreen`, simulator launch screenshot full-screen with no letterbox, `grep -i storyboard project.md` empty
## Risks
- Phase 1 must be done in one step: keeping `AppDelegate`'s `@main` next to the new `App` struct fails to compile ("multiple @main"), and removing `Main.storyboard` while `UIMainStoryboardFile` is still set crashes at launch.
- The pbxproj edits are hand edits (the ios-swift skill says avoid unless unavoidable). They are 4 single-line build-setting changes; the alternative is doing them in Xcode → target → Build Settings / Info. No signing, provisioning, or entitlement settings are touched.
- No test target exists, so verification is build + launch only. Builds need a Mac with Xcode; a cloud session can't run Phase acceptance (see `TARA_NOTES.md`).
- The `thai-translator` scheme isn't shared (no `.xcscheme`); `xcodebuild` normally auto-creates it, but if it fails, open the project in Xcode once or run `xcodebuild -list`.
## Decisions
- Delete the UIKit template files instead of keeping a `UIApplicationDelegateAdaptor`: no app-delegate behavior is needed yet; one can be added later (e.g. for notifications) without UIKit screens.
- Keep `Info.plist` (now an empty dict) rather than deleting it: F2–F5 need `NSCameraUsageDescription` and other usage strings there. Confirm, or say if you'd rather use `INFOPLIST_KEY_*` build settings only.
- Use `INFOPLIST_KEY_UILaunchScreen_Generation` (plain launch screen from the accent/background color) instead of a SwiftUI-unrelated launch storyboard; no new libraries.
- Out of scope, needs your call separately: deployment target is 26.2 while `PLAN.md` says 17.4+; adding a unit test target (Swift Testing) so `project.md` can get a real test command.
