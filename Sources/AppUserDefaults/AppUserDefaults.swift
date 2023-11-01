import ConfigurationWrapper
import Defaults
import Dependencies
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
  public static let testValue = AppUserDefaults.unimplemented
}

extension DependencyValues {
  public var appUserDefaults: AppUserDefaults {
    get { self[AppUserDefaultsKey.self] }
    set { self[AppUserDefaultsKey.self] = newValue }
  }
}

public struct AppUserDefaults {
  public var getConfigurationWrapper: () -> ConfigurationWrapper
  public var setConfigurationWrapper: (ConfigurationWrapper) -> Void
  public var getShouldTrimTrailingWhitespace: () -> Bool
  public var setShouldTrimTrailingWhitespace: (Bool) -> Void
  public var getDidRunBefore: () -> Bool
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

extension AppUserDefaults {
  public static let unimplemented = Self(
    getConfigurationWrapper: XCTUnimplemented(
      "\(Self.self).getConfigurationWrapper",
      placeholder: ConfigurationWrapper()
    ),
    setConfigurationWrapper: XCTUnimplemented("\(Self.self).setConfigurationWrapper"),
    getShouldTrimTrailingWhitespace: XCTUnimplemented(
      "\(Self.self).getShouldTrimTrailingWhitespace",
      placeholder: false
    ),
    setShouldTrimTrailingWhitespace: XCTUnimplemented(
      "\(Self.self).setShouldTrimTrailingWhitespace"
    ),
    getDidRunBefore: XCTUnimplemented("\(Self.self).getDidRunBefore", placeholder: false),
    setDidRunBefore: XCTUnimplemented("\(Self.self).setDidRunBefore")
  )
}
