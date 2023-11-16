import ConfigurationWrapper
import Defaults
import Dependencies
import DependenciesMacros
import Foundation
import SwiftFormat
import XCTestDynamicOverlay

let appUserDefaultsSuite = UserDefaults(suiteName: "group.com.kuglee.SwiftFormatter")!

extension Defaults.Keys {
  static let didRunBefore = Key<Bool>("didRunBefore", default: false, suite: appUserDefaultsSuite)
  static let configuration = Key<Configuration>(
    "configuration",
    default: Configuration(),
    suite: appUserDefaultsSuite
  )
  static let shouldTrimTrailingWhitespace = Key<Bool>(
    "shouldTrimTrailingWhitespace",
    default: false,
    suite: appUserDefaultsSuite
  )
}

extension Configuration: Defaults.Serializable {}

public enum AppUserDefaultsKey: DependencyKey {
  public static let liveValue = AppUserDefaults.live
  public static let testValue = AppUserDefaults()
}

extension DependencyValues {
  public var appUserDefaults: AppUserDefaults {
    get { self[AppUserDefaultsKey.self] }
    set { self[AppUserDefaultsKey.self] = newValue }
  }
}

@DependencyClient public struct AppUserDefaults {
  public var getConfigurationWrapper: () -> ConfigurationWrapper = { ConfigurationWrapper() }
  public var setConfigurationWrapper: (_: ConfigurationWrapper) -> Void
  public var getShouldTrimTrailingWhitespace: () -> Bool = { false }
  public var setShouldTrimTrailingWhitespace: (_: Bool) -> Void
  public var getDidRunBefore: () -> Bool = { false }
  public var setDidRunBefore: (Bool) -> Void
}

extension AppUserDefaults {
  public static let live = Self(
    getConfigurationWrapper: { ConfigurationWrapper(configuration: Defaults[.configuration]) },
    setConfigurationWrapper: { newValue in Defaults[.configuration] = newValue.toConfiguration() },
    getShouldTrimTrailingWhitespace: { Defaults[.shouldTrimTrailingWhitespace] },
    setShouldTrimTrailingWhitespace: { newValue in
      Defaults[.shouldTrimTrailingWhitespace] = newValue
    },
    getDidRunBefore: { Defaults[.didRunBefore] },
    setDidRunBefore: { newValue in Defaults[.didRunBefore] = newValue }
  )
}
