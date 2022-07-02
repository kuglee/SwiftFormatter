import Foundation
import SwiftFormatConfiguration
import os.log
import AppConstants

public func loadConfiguration(fromJSON configurationJSON: String?) -> Configuration {
  if let configurationJSON = configurationJSON, let data = configurationJSON.data(using: .utf8) {
    do {
      return try JSONDecoder().decode(Configuration.self, from: data)
    } catch {
      os_log("Could not load configuration: %{public}@", error.localizedDescription)
    }
  }

  return Configuration()
}

public func loadConfiguration2(fromFileAtPath configurationFileURL: URL) -> Configuration {
  do {
    return try Configuration(contentsOf: configurationFileURL)
  } catch {
    os_log(
      "Could not load configuration at %{public}@: %{public}@",
      configurationFileURL.absoluteString,
      error.localizedDescription
    )
  }

  return Configuration()
}

public func dumpConfiguration(configuration: Configuration) {
  do {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted]
    encoder.outputFormatting.insert(.sortedKeys)

    let data = try encoder.encode(configuration)
    guard let jsonString = String(data: data, encoding: .utf8) else {
      os_log("Could not dump the default configuration: the JSON was not valid UTF-8")
      return
    }

    setConfiguration(jsonString)

  } catch { os_log("Could not dump the default configuration: %{public}@", error.localizedDescription) }
}

func setConfiguration(_ newValue: String) {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .set(newValue, forKey: AppConstants.configurationKey)
}
