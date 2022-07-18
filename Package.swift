// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Modules",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "FormatterSettings", targets: ["FormatterSettings"]),
    .library(name: "FormatterRules", targets: ["FormatterRules"]),
    .library(name: "StyleGuide", targets: ["StyleGuide"]),
    .library(name: "Utility", targets: ["Utility"]),
    .library(name: "ConfigurationManager", targets: ["ConfigurationManager"]),
    .library(name: "Settings", targets: ["Settings"]),
    .library(name: "AppConstants", targets: ["AppConstants"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.9.0"),
    .package(url: "https://github.com/apple/swift-format", branch: "release/5.6"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "ConfigurationManager",
        "Settings",
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        "StyleGuide",
        "AppConstants",
      ]
    ),
    .target(
      name: "FormatterSettings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"), "StyleGuide",
        "AppConstants",
        "Utility",
      ]
    ),
    .target(
      name: "FormatterRules",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "StyleGuide",
        "AppConstants",
        "Utility",
      ]
    ),
    .target(name: "StyleGuide" ,dependencies: []),
    .target(name: "Utility", dependencies: []),
    .target(
      name: "ConfigurationManager",
      dependencies: [
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        "AppConstants",
      ]
    ),
    .target(
      name: "Settings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        "FormatterSettings",
        "FormatterRules",
        "StyleGuide",
        "AppConstants",
      ]
    ),
    .target(name: "AppConstants" ,dependencies: []),
  ]
)
