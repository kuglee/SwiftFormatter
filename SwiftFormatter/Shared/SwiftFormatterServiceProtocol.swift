import Foundation

@objc protocol SwiftFormatterServiceProtocol {
  func format(source: String, useConfigurationAutodiscovery: Bool, reply: @escaping (String?, Error?) -> Void)
}
