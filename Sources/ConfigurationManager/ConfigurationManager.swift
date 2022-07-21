import AppConstants
import Foundation
import SwiftFormatConfiguration
import os.log

public func loadConfiguration(fromFileAtPath configurationFileURL: URL) -> Configuration {
  do { return try Configuration(contentsOf: configurationFileURL) }
  catch {
    os_log(
      "Could not load configuration at %{public}@: %{public}@",
      configurationFileURL.absoluteString,
      error.localizedDescription
    )
  }

  return Configuration()
}

public func dumpConfiguration(
  configuration: Configuration,
  outputFileURL: URL,
  createIntermediateDirectories: Bool = false
) {
  do {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted]
    encoder.outputFormatting.insert(.sortedKeys)

    let data = try encoder.encode(configuration)
    guard let jsonString = String(data: data, encoding: .utf8) else {
      os_log("Could not dump the default configuration: the JSON was not valid UTF-8")
      return
    }

    if createIntermediateDirectories {
      try? FileManager.default.createDirectory(
        at: outputFileURL.deletingLastPathComponent(),
        withIntermediateDirectories: true
      )
    }

    try jsonString.write(to: outputFileURL, atomically: false, encoding: .utf8)
  }
  catch {
    os_log("Could not dump the default configuration: %{public}@", error.localizedDescription)
  }
}

public func getShouldTrimTrailingWhitespace() -> Bool {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .bool(forKey: AppConstants.shouldTrimTrailingWhitespaceKey)
}

public func setShouldTrimTrailingWhitespace(newValue: Bool) {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .set(newValue, forKey: AppConstants.shouldTrimTrailingWhitespaceKey)
}
