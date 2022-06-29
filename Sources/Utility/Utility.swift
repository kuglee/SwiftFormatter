import SwiftUI

public enum AppConstants {
  public static let applicationSupportDirectory = FileManager.default
    .urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    .appendingPathComponent("Swift Formatter")
  public static let configFilename = "swift-format.json"

  public static var configFileURL: URL {
    AppConstants.applicationSupportDirectory.appendingPathComponent(AppConstants.configFilename)
  }
  public static let didRunBeforeKey = "didRunBefore"
  public static let useConfigurationAutodiscovery = "useConfigurationAutodiscovery"
}

public class UIntNumberFormatter: NumberFormatter {
  public override init() {
    super.init()

    self.allowsFloats = false
    self.minimum = 0
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Collection {
  public func enumeratedArray() -> [(offset: Int, element: Self.Element)] {
    return Array(self.enumerated())
  }
}
