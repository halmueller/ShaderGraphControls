# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

ShaderGraphControls is a visionOS sample app demonstrating live ShaderGraph material parameter control via SwiftUI sliders. RGB color values are fed from `ViewModel` into a ShaderGraph material (`Pipeline.usda`) applied to a cube entity.

## Build & Test

Xcode project, no Makefile. Build via Xcode or `xcodebuild`:

```bash
xcodebuild -project ShaderGraphControls.xcodeproj -scheme ShaderGraphControls \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' build
```

A test target exists (`ShaderGraphControlsTests`) but contains only the unmodified Xcode template stub — no real tests.

## Architecture

### Data flow
- `ViewModel` — `@Observable` class holding `red`, `green`, `blue: Float` and `rootEntity: Entity?`
- `ShaderGraphControlsApp` — holds `@State private var viewModel = ViewModel()`; passes it to `ContentView` as a plain `var` argument (correct `@Observable` pattern — not `@EnvironmentObject`)
- `ContentView` — receives `viewModel: ViewModel`; uses `@Bindable var viewModel = viewModel` for slider bindings; `RealityView` `update:` closure calls `viewModel.updateParameters()` on every state change

### RealityKit integration
- `ContentView` `make:` closure loads `Pipeline.usda` scene; assigns root entity to `viewModel.rootEntity`
- `ViewModel.updateParameters()` finds entity named `"Cube"`, extracts its `ModelComponent`, casts the first material to `ShaderGraphMaterial`, sets `red`/`green`/`blue` float parameters, and writes the component back
- Parameter name strings (`"red"`, `"green"`, `"blue"`, `"Cube"`) must match the input node names in `Pipeline.usda`

### Dependencies (SPM)
- **RealityKitContent** — local package at `Packages/RealityKitContent/` providing `Pipeline.usda`

### Deployment target
visionOS (see project settings).

## Known Issues & Fix Plan

### Performance
- **Triple entity-tree traversal per update** (`ViewModel.swift:29–43`): `updateParameters()` calls `update(parameter:newValue:)` three times; each call independently runs `findEntity(named: "Cube")`, extracts `ModelComponent`, and casts the material. Consolidate into a single lookup in `updateParameters()`, apply all three `setParameter` calls, then write the component back once. Remove the separate `update(parameter:newValue:)` method.

### Dead debug code
- `ViewModel.swift:21` — `print(#function, "****", rootEntity)` fires on every `RealityView` update cycle; remove
- `ViewModel.swift:30` — `print(#function, parameter, newValue)` fires on every slider event; remove

### Error handling
- `ViewModel.swift:41` — `catch` block prints `"unhandled error"` with no context; change to `print("setParameter failed: \(error)")` at minimum

### Magic strings
- Entity name `"Cube"` (line 30) and parameter names `"red"`, `"green"`, `"blue"` (lines 24–26) are inline string literals. Extract entity name to a `private let` constant. The code already has a comment (line 22) noting that parameter names should be an enum.

### Dead files
- `ShaderGraphControlsTests/ShaderGraphControlsTests.swift` — unmodified Xcode template; all test methods have empty bodies. Delete or replace with real tests.

### Minor
- `updateParameters()` is called by the `update:` closure before `rootEntity` is set (during initial load); the `guard` early-exits cleanly but add an explicit `guard rootEntity != nil else { return }` at the top of `updateParameters()` for clarity.
