// swift-tools-version: 5.6

import PackageDescription

let xcodeKitFrameworkPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/"

let package = Package(
  name: "SwiftFormatter",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "App", targets: ["App"]),
    .library(name: "AppAssets", targets: ["AppAssets"]),
    .library(name: "AppExtension", targets: ["AppExtension"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AppUserDefaults", targets: ["AppUserDefaults"]),
    .library(name: "ConfigurationWrapper", targets: ["ConfigurationWrapper"]),
    .library(name: "FormatterRules", targets: ["FormatterRules"]),
    .library(name: "FormatterSettings", targets: ["FormatterSettings"]),
    .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    .library(name: "StyleGuide", targets: ["StyleGuide"]),
    .library(name: "WelcomeFeature", targets: ["WelcomeFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.41.2"),
    .package(url: "https://github.com/kuglee/swift-format", branch: "release/5.7"),
    .package(url: "https://github.com/sindresorhus/Defaults", branch: "v6.3.0"),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        "AppAssets",
        "AppFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AppAssets",
      dependencies: [],
      resources: [
        .process("Assets.xcassets")
      ]
    ),
    .target(
      name: "AppExtension",
      dependencies: [
        "AppUserDefaults",
        .product(name: "SwiftFormat", package: "swift-format"),
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
    .target(
      name: "WelcomeFeature",
      dependencies: [
        "AppAssets",
        "StyleGuide",
      ]
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
