// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Modules",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "App", targets: ["App"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "FormatterSettings", targets: ["FormatterSettings"]),
    .library(name: "FormatterRules", targets: ["FormatterRules"]),
    .library(name: "StyleGuide", targets: ["StyleGuide"]),
    .library(name: "Settings", targets: ["Settings"]),
    .library(name: "AppUserDefaults", targets: ["AppUserDefaults"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.9.0"),
    .package(url: "https://github.com/apple/swift-format", branch: "release/5.6"),
    .package(url: "https://github.com/sindresorhus/Defaults", branch: "v6.3.0"),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "AppUserDefaults",
        "AppFeature",
        "Defaults",
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Settings",
        "Defaults",
      ]
    ),
    .target(
      name: "FormatterSettings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"), "StyleGuide",
      ]
    ),
    .target(
      name: "FormatterRules",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "StyleGuide",
      ]
    ),
    .target(name: "StyleGuide" ,dependencies: []),
    .target(
      name: "Settings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        "FormatterSettings",
        "FormatterRules",
        "StyleGuide",
      ]
    ),
    .target(
      name: "AppUserDefaults",
      dependencies: [
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        "Defaults",
      ]
    ),
  ]
)
