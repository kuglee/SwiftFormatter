import ComposableArchitecture
import Defaults
import Foundation
import SwiftFormatConfiguration
import XCTestDynamicOverlay
import os.log

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
  public var getConfiguration: () -> Configuration
  public var setConfiguration: (Configuration) -> Void
  public var getShouldTrimTrailingWhitespace: () -> Bool
  public var setShouldTrimTrailingWhitespace: (Bool) -> Void
  public var getDidRunBefore: () -> Bool
  public var setDidRunBefore: (Bool) -> Void
}

extension AppUserDefaults {
  public static let live = Self(
    getConfiguration: { Defaults[.configuration] },
    setConfiguration: { newValue in Defaults[.configuration] = newValue },
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
    getConfiguration: XCTUnimplemented(
      "\(Self.self).getConfiguration",
      placeholder: Configuration()
    ),
    setConfiguration: XCTUnimplemented("\(Self.self).setConfiguration"),
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
