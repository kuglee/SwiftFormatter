import Foundation

@objc public protocol SwiftFormatterServiceProtocol {
  func format(
    source: String,
    useConfigurationAutodiscovery: Bool,
    reply: @escaping (String?, Error?) -> Void
  )
}
