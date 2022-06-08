// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Modules",
  platforms: [.macOS(.v11)],
  products: [
    .library(name: "Settings", targets: ["Settings"]), .library(name: "Rules", targets: ["Rules"]),
    .library(name: "About", targets: ["About"]),
    .library(name: "StyleGuide", targets: ["StyleGuide"]),
    .library(name: "Utility", targets: ["Utility"]),
    .library(name: "ConfigurationManager", targets: ["ConfigurationManager"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.9.0"),
    .package(url: "https://github.com/apple/swift-format", branch: "release/5.6"),
  ],
  targets: [
    .target(
      name: "Settings",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftFormatConfiguration", package: "swift-format"), "StyleGuide",
        "Utility",
      ]
    ),
    .target(
      name: "Rules",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "StyleGuide", "Utility",
      ]
    ),
    .target(name: "About", dependencies: ["StyleGuide"]),
    .target(name: "StyleGuide", dependencies: []),
    .target(name: "Utility", dependencies: []),
    .target(
      name: "ConfigurationManager",
      dependencies: [.product(name: "SwiftFormatConfiguration", package: "swift-format")]
    ),
  ]
)
