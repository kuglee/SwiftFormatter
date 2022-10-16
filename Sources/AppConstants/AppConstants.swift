import Foundation

public enum AppConstants {
  public static let appGroupName = "group.com.kuglee.SwiftFormatter"
  private static let configFilename = "swift-format.json"
  public static let configFileURL = FileManager.default.containerURL(
    forSecurityApplicationGroupIdentifier: appGroupName
  )!
  .appendingPathComponent(AppConstants.configFilename)
  public static let xpcServiceName = "com.kuglee.SwiftFormatter.service"
}
