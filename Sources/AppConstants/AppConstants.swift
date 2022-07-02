import Foundation

public enum AppConstants {
  public static let appGroupName = "group.com.kuglee.SwiftFormatter"
  public static let configurationKey = "configurationKey"
  public static let didRunBeforeKey = "didRunBefore"
  public static let useConfigurationAutodiscoveryKey = "useConfigurationAutodiscovery"
}

public func getConfiguration() -> String? {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .string(forKey: AppConstants.configurationKey)
}
