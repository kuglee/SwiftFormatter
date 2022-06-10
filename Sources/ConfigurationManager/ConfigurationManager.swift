import SwiftFormatConfiguration
import Foundation
import os.log

public func loadConfiguration(fromFileAtPath path: URL?) -> Configuration {
  if let path = path {
    do {
      let data = try Data(contentsOf: path)
      return try JSONDecoder().decode(Configuration.self, from: data)
    } catch {
      os_log(
        "Could not load configuration at %{public}@: %{public}@", path.absoluteString,
        error.localizedDescription)
    }
  }

  return Configuration()
}

public func dumpConfiguration(
  configuration: Configuration = Configuration(), outputFileURL: URL,
  createIntermediateDirectories: Bool = false
) {
  do {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted]
    if #available(macOS 10.13, *) { encoder.outputFormatting.insert(.sortedKeys) }

    let data = try encoder.encode(configuration)
    guard let jsonString = String(data: data, encoding: .utf8) else {
      print("Could not dump the default configuration: the JSON was not valid UTF-8")
      return
    }

    do {
      if createIntermediateDirectories {
        try? FileManager.default.createDirectory(
          at: outputFileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
      }

      try jsonString.write(to: outputFileURL, atomically: false, encoding: .utf8)
    } catch { print("Could not dump the default configuration: \(error)") }
  } catch { print("Could not dump the default configuration: \(error)") }
}
