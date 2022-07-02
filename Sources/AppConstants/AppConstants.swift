import Foundation

public enum AppConstants {
  public static let appGroupName = "group.com.kuglee.SwiftFormatter"
  public static let configurationKey = "configuration"
  public static let didRunBeforeKey = "didRunBefore"
}

public func getConfiguration() -> String? {
  UserDefaults(suiteName: AppConstants.appGroupName)!.string(forKey: AppConstants.configurationKey)
}
