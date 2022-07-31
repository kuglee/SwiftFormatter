// swift-tools-version: 5.6

import PackageDescription

let xcodeKitFrameworkPath = "/Applications/Xcode-beta.app/Contents/Developer/Library/Frameworks/"

let package = Package(
  name: "SwiftFormatter",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "App", targets: ["App"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "FormatterSettings", targets: ["FormatterSettings"]),
    .library(name: "FormatterRules", targets: ["FormatterRules"]),
    .library(name: "StyleGuide", targets: ["StyleGuide"]),
    .library(name: "Settings", targets: ["Settings"]),
    .library(name: "AppUserDefaults", targets: ["AppUserDefaults"]),
    .library(name: "AppExtension", targets: ["AppExtension"]),
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
        "StyleGuide",
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        "Settings",
        "Defaults",
      ]
    ),
    .target(
      name: "FormatterSettings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"),
        "StyleGuide",
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
    .target(
      name: "AppExtension",
      dependencies: [
        .product(name: "SwiftFormat", package: "swift-format"),
        "AppUserDefaults",
        "Defaults",
      ],
      swiftSettings: [
          .unsafeFlags([
              "-Fsystem", xcodeKitFrameworkPath,
          ]),
      ]
    )
  ]
)
