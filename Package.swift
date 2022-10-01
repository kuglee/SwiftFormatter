// swift-tools-version: 5.6

import PackageDescription

let xcodeKitFrameworkPath = "/Applications/Xcode-beta.app/Contents/Developer/Library/Frameworks/"

let package = Package(
  name: "SwiftFormatter",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "App", targets: ["App"]),
    .library(name: "AppExtension", targets: ["AppExtension"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AppUserDefaults", targets: ["AppUserDefaults"]),
    .library(name: "FormatterRules", targets: ["FormatterRules"]),
    .library(name: "FormatterSettings", targets: ["FormatterSettings"]),
    .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    .library(name: "StyleGuide", targets: ["StyleGuide"]),
    .library(name: "WelcomeFeature", targets: ["WelcomeFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "protocol-beta"),
    .package(url: "https://github.com/apple/swift-format", branch: "release/5.7"),
    .package(url: "https://github.com/sindresorhus/Defaults", branch: "v6.3.0"),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        "AppFeature",
        "AppUserDefaults",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "WelcomeFeature",
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
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Defaults",
        "SettingsFeature",
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
      ]
    ),
    .target(
      name: "AppUserDefaults",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Defaults",
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
      ]
    ),
    .target(
      name: "FormatterRules",
      dependencies: [
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
        "FormatterRules",
        "FormatterSettings",
        "StyleGuide",
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
      ]
    ),
    .target(name: "StyleGuide" ,dependencies: []),
    .target(
      name: "WelcomeFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "StyleGuide",
      ]
    ),
  ]
)
