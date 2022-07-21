import Foundation

public enum AppConstants {
  public static let appGroupName = "group.com.kuglee.SwiftFormatter"
  public static let didRunBeforeKey = "didRunBefore"
  public static let shouldTrimTrailingWhitespaceKey = "shouldTrimTrailingWhitespace"
  static let configFilename = "swift-format.json"
  public static let configFileURL = FileManager.default.containerURL(
    forSecurityApplicationGroupIdentifier: appGroupName
  )!
  .appendingPathComponent(AppConstants.configFilename)
  public static let xpcServiceName = "com.kuglee.SwiftFormatter.service"
}
