// swift-tools-version: 5.6

import PackageDescription

let xcodeKitFrameworkPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/"

let package = Package(
  name: "SwiftFormatter",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "App", targets: ["App"]),
    .library(name: "AppConstants", targets: ["AppConstants"]),
    .library(name: "AppExtension", targets: ["AppExtension"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AppUserDefaults", targets: ["AppUserDefaults"]),
    .library(name: "ConfigurationWrapper", targets: ["ConfigurationWrapper"]),
    .library(name: "FormatterRules", targets: ["FormatterRules"]),
    .library(name: "FormatterSettings", targets: ["FormatterSettings"]),
    .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    .library(name: "StyleGuide", targets: ["StyleGuide"]),
    .library(name: "SwiftFormatterServiceProtocol", targets: ["SwiftFormatterServiceProtocol"]),
    .library(name: "WelcomeFeature", targets: ["WelcomeFeature"]),
    .executable(name: "SwiftFormatterService", targets: ["SwiftFormatterService"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.41.2"),
    .package(url: "https://github.com/apple/swift-format", branch: "release/5.7"),
    .package(url: "https://github.com/sindresorhus/Defaults", branch: "v6.3.0"),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        "AppFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(name: "AppConstants" ,dependencies: []),
    .target(
      name: "AppExtension",
      dependencies: [
        "AppConstants",
        "AppUserDefaults",
        "SwiftFormatterServiceProtocol",
      ],
      swiftSettings: [
          .unsafeFlags([
              "-Fsystem", xcodeKitFrameworkPath,
          ]),
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        "AppUserDefaults",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "SettingsFeature",
        "WelcomeFeature",
      ]
    ),
    .target(
      name: "AppUserDefaults",
      dependencies: [
        "AppConstants",
        "ConfigurationWrapper",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Defaults",
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
      ]
    ),
    .target(
      name: "ConfigurationWrapper",
      dependencies: [
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
      ]
    ),
    .target(
      name: "FormatterRules",
      dependencies: [
        "ConfigurationWrapper",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "StyleGuide",
      ]
    ),
    .target(
      name: "FormatterSettings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "StyleGuide",
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
      ]
    ),
    .target(
      name: "SettingsFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "ConfigurationWrapper",
        "FormatterRules",
        "FormatterSettings",
        "StyleGuide",
      ]
    ),
    .target(name: "StyleGuide" ,dependencies: []),
    .target(name: "SwiftFormatterServiceProtocol", dependencies: []),
    .target(
      name: "WelcomeFeature",
      dependencies: [
        "StyleGuide",
      ]
    ),
    .executableTarget(
      name: "SwiftFormatterService",
      dependencies: ["SwiftFormatterServiceProtocol", "AppUserDefaults"],
      exclude: ["SwiftFormatterService.plist"]
    ),
    .testTarget(
      name: "FormatterSettingsTests",
      dependencies: [
        "FormatterSettings",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
      ]
    ),
    .testTarget(
      name: "FormatterRulesTests",
      dependencies: [
        "ConfigurationWrapper",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "FormatterRules",
      ]
    ),
  ]
)
