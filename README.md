# BSKit

BSKit is a modular, protocol-oriented base framework designed to provide a consistent and scalable foundation for iOS applications. It encapsulates best practices, foundational base classes, and core utilities for both UIKit and SwiftUI.

## Features

- **BSCoreKit**: Framework-agnostic shared utilities, image caching, and dependency injection protocols.
- **BSUIKit**: Foundational base classes for UIKit (`BaseViewController`, `BaseViewModel`, `BaseRouter`, `BaseView`).
- **BSSwiftUI**: SwiftUI-specific base components and utilities like `CachedAsyncImage`.
- **BSNetworkKit**: A robust networking layer built on URLSession with support for retries and error handling.

## Requirements

- **iOS** 16.0+
- **macOS** 13.0+ (Core and Network kits)
- **Xcode** 15.0+
- **Swift** 5.9+

## Installation

Add BSKit to your project using Swift Package Manager by pointing to this repository.

Then import the specific modules you need:

```swift
import BSCoreKit
import BSUIKit
import BSSwiftUI
import BSNetworkKit
```

## Example Project: DemoProject

The repository includes a comprehensive example project located in the `Examples/` directory. `DemoProject` demonstrates how to build a modern movie browsing app using the BSKit framework.

### Demo App Features
- 🎬 Browse latest movies with infinite scroll pagination
- 🔍 Search movies with debounced input
- 📱 Movie detail view with rich metadata
- 🌙 Dark mode and Accessibility support
- 🌍 Full localization (English & German)

### Running the Example

1. **Configure API Key**:
   The app uses The Movie Database (TMDB) API. 
   
   ```bash
   # Copy the template secrets file
   cp Examples/DemoProject/Configuration/Secrets.xcconfig.template Examples/DemoProject/Configuration/Secrets.xcconfig
   ```
   
   Open `Examples/DemoProject/Configuration/Secrets.xcconfig` and add your [TMDB API Key](https://www.themoviedb.org/settings/api).

2. **Open and Run**:
   ```bash
   open Examples/DemoProject.xcodeproj
   ```

## Repository Structure

```
.
├── Package.swift          # Main BSKit Umbrella Package
├── Packages/              # Sub-package implementations
│   ├── BSCoreKit/        # Shared core utilities
│   ├── BSUIKit/          # UIKit base components
│   ├── BSSwiftUI/        # SwiftUI base components
│   └── BSNetworkKit/     # Basic networking tools
├── Examples/              # Reference implementations
│   └── DemoProject/      # Full iOS App showcasing BSKit
└── Sources/               # Package wrapper targets
```

## Architecture & Principles

BSKit is built with high standards for code quality:
- **SOLID Principles**: Focused on maintainability and separation of concerns.
- **Protocol-Oriented Programming**: Designed for high testability and flexibility.
- **Generic Architecture**: Base classes use generics to enforce type safety (Input/State pattern).
- **Modular by Design**: Import only what you need, reducing app size and build times.

## License

This project is for demonstration and baseline project purposes.
