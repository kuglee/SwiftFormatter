import Foundation
import SwiftFormatConfiguration
import os.log

public struct AppUserDefaults {
  public static let appGroupName = "group.com.kuglee.SwiftFormatter"

  struct Keys {
    public static let configuration = "configuration"
    public static let didRunBefore = "didRunBefore"
    public static let shouldTrimTrailingWhitespace = "shouldTrimTrailingWhitespace"
  }

  public static var configuration: Configuration {
    get {
      guard
        let configurationJSON = UserDefaults(suiteName: self.appGroupName)!
          .string(forKey: self.Keys.configuration)
      else { return Configuration() }

      return (try? Configuration(fromJSON: configurationJSON)) ?? Configuration()
    }
    set {
      guard let configurationJSON = newValue.toJSON() else { return }

      UserDefaults(suiteName: self.appGroupName)!
        .set(configurationJSON, forKey: self.Keys.configuration)
    }
  }

  public static var shouldTrimTrailingWhitespace: Bool {
    get {
      UserDefaults(suiteName: self.appGroupName)!
        .bool(forKey: self.Keys.shouldTrimTrailingWhitespace)
    }
    set {
      UserDefaults(suiteName: self.appGroupName)!
        .set(newValue, forKey: self.Keys.shouldTrimTrailingWhitespace)
    }
  }

  public static var didRunBefore: Bool {
    get { UserDefaults(suiteName: self.appGroupName)!.bool(forKey: self.Keys.didRunBefore) }
    set {
      UserDefaults(suiteName: self.appGroupName)!.set(newValue, forKey: self.Keys.didRunBefore)
    }
  }
}

extension Configuration {
  init(fromJSON configurationJSON: String) throws {
    let data = configurationJSON.data(using: .utf8)!
    self = try JSONDecoder().decode(Configuration.self, from: data)
  }

  func toJSON() -> String? {
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted]
      encoder.outputFormatting.insert(.sortedKeys)

      let configurationData = try encoder.encode(self)
      guard let configurationJSON = String(data: configurationData, encoding: .utf8) else {
        os_log("Could not dump the default configuration: the JSON was not valid UTF-8")
        return nil
      }

      return configurationJSON
    }
    catch {
      os_log("Could not dump the default configuration: %{public}@", error.localizedDescription)
      return nil
    }
  }
}
