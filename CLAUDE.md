# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sseudam-iOS is a modular iOS app built with SwiftUI and The Composable Architecture (TCA), using Tuist for project generation and dependency management. The app helps users report and track trash spots with their virtual pet companion.

## Build System & Commands

### Tuist Commands
- `tuist generate` - Generate Xcode workspace from project manifests
- `tuist build` - Build the project
- `tuist test` - Run tests
- `tuist clean` - Clean build artifacts
- `tuist cache` - Manage build cache
- `tuist install` - Install dependencies (run after Package.swift changes)

### Build Schemes
- **develop** - Debug configuration using `Sseudam_develop` target
- **release** - Release configuration using `Sseudam` target

### Testing
Tests are located in modules ending with `Testing` (e.g., `AuthDataTesting`, `DomainTesting`). Run tests with `tuist test` or through Xcode schemes.

## Architecture

### Modular Structure
The project follows Clean Architecture patterns with strict module separation:

```
Projects/
├── Core/           # Shared infrastructure (DesignKit, NetworkKit, Cache)
├── Shared/         # Utilities (KeyChain, UserDefaults, Utility)
├── Data/           # Repository implementations and DTOs
├── Domain/         # Business logic, use cases, and entities  
├── Feature/        # UI features using TCA
└── Sseudam/        # Main app target
```

### Module Types
- **Interface modules** (`*Interface`) - Define protocols and contracts
- **Implementation modules** (`*Data`, `*Domain`) - Concrete implementations
- **Testing modules** (`*Testing`) - Test utilities and mocks
- **Feature modules** (`*Feature`) - UI components with TCA reducers

### Key Patterns
- **TCA (The Composable Architecture)** - State management for all features
- **Repository Pattern** - Data layer abstraction via interfaces
- **Use Case Pattern** - Domain logic encapsulation
- **Dependency Injection** - Using TCA's `@Dependency` system

### Major Dependencies
- ComposableArchitecture (v1.20.1) - State management
- NMapsMap (v3.21.0) - Naver Maps integration
- DotLottie (v0.8.3) - Lottie animations

## Key Concepts

### Authentication Flow
Apple Sign-In only authentication flow:
1. `LoginFeature` handles Apple authorization
2. Token exchange with backend via `AppleLoginUseCase`
3. User info fetching and storage
4. Flow routing (signup vs. main app) based on token type

### Feature Architecture
Each feature follows TCA patterns:
- `*Feature.swift` - Reducer with State, Action, and business logic
- `*View.swift` - SwiftUI view bound to store
- Features compose hierarchically (e.g., tab roots, auth flow)

### Data Flow
1. **UI** - TCA Views send Actions to Reducers
2. **Feature Layer** - Reducers handle Actions, call Use Cases
3. **Domain Layer** - Use Cases orchestrate business logic
4. **Data Layer** - Repositories handle API/persistence

### Module Dependencies
- Features depend on Domain interfaces (not implementations)
- Domain implementations depend on Data interfaces
- Data implementations handle external services
- Circular dependencies prevented by interface segregation

## Development Workflow

1. Generate workspace: `tuist generate`
2. Install dependencies: `tuist install` (when Package.swift changes)
3. Build with scheme: develop (debug) or release
4. Run tests: `tuist test` or through Xcode
5. Clean when needed: `tuist clean`

## Project Generation Templates

Tuist templates available for scaffolding:
- `tuist scaffold Feature` - New feature with TCA boilerplate
- `tuist scaffold Domain` - Domain layer with use cases  
- `tuist scaffold Data` - Data layer with repositories