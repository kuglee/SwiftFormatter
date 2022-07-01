import Foundation

public enum AppConstants {
  static let applicationSupportDirectory = FileManager.default
    .urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    .appendingPathComponent("Swift Formatter")
  static let configFilename = "swift-format.json"
  public static let configFileURL = AppConstants.applicationSupportDirectory.appendingPathComponent(
    AppConstants.configFilename
  )
  public static let didRunBeforeKey = "didRunBefore"
  public static let useConfigurationAutodiscoveryKey = "useConfigurationAutodiscovery"
  public static let appGroupName = "group.com.kuglee.SwiftFormatter"
}
