# tara Gaps Log

Notes from building thai-translator with tara. This becomes the tara backlog after the trip.

Log here:
- Anything you had to explain manually
- Commands that felt too generic
- Missing iOS-specific steps

## Gaps

### Cloud sessions have no Xcode toolchain
- **Seen:** 2026-10-19, during setup in a Claude Code cloud session.
- **What happened:** The cloud container runs Linux, with no `swift`, `xcodebuild`, or `swiftformat`. `/tara:build` and `/tara:test` can't run there, and `format.sh` skips `.swift` files without saying so.
- **Idea:** Detect a missing Apple toolchain up front. Have `build`/`test` say so clearly and fall back to a manual checklist, and have `format.sh` warn once per session instead of skipping silently.

### tara isn't loaded unless the repo opts in
- **Seen:** 2026-10-19.
- **What happened:** tara isn't in the claude.ai plugin catalog, so a cloud session only loads it when the repo's `.claude/settings.json` lists the marketplace and enables the plugin.
- **Idea:** Document the `settings.json` snippet in the tara README, or have `/tara:init` offer to write it.
