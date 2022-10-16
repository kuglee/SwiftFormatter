import AppConstants
import ConfigurationWrapper
import Defaults
import Dependencies
import Foundation
import SwiftFormatConfiguration
import XCTestDynamicOverlay
import os.log

let appUserDefaultsSuite = UserDefaults(suiteName: AppConstants.appGroupName)!

extension Defaults.Keys {
  static let didRunBefore = Key<Bool>("didRunBefore", default: false, suite: appUserDefaultsSuite)
  static let shouldTrimTrailingWhitespace = Key<Bool>(
    "shouldTrimTrailingWhitespace",
    default: false,
    suite: appUserDefaultsSuite
  )
}

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
    getConfigurationWrapper: {
      let configuration =
        (try? Configuration(contentsOf: AppConstants.configFileURL)) ?? Configuration()

      return ConfigurationWrapper(configuration: configuration)
    },
    setConfigurationWrapper: { configurationWrapper in
      do {
        let jsonString = try configurationWrapper.toConfiguration().toJSON()

        try? FileManager.default.createDirectory(
          at: AppConstants.configFileURL.deletingLastPathComponent(),
          withIntermediateDirectories: true
        )

        try jsonString.write(to: AppConstants.configFileURL, atomically: false, encoding: .utf8)
      } catch { os_log("%{public}@", error.localizedDescription) }
    },
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

extension Configuration {
  func toJSON() throws -> String {
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted]
      encoder.outputFormatting.insert(.sortedKeys)

      let data = try encoder.encode(self)
      guard let jsonString = String(data: data, encoding: .utf8) else {
        throw ConfigurationError.encodingError
      }

      return jsonString
    } catch { throw ConfigurationError.dumpError(cause: error) }
  }
}

enum ConfigurationError: Error, LocalizedError {
  case encodingError
  case dumpError(cause: Error)

  var localizedDescription: String {
    switch self {
    case .encodingError:
      return "Could not dump the default configuration: the JSON was not valid UTF-8"
    case let .dumpError(cause): return "Could not dump the default configuration: \(cause)"
    }
  }
}
