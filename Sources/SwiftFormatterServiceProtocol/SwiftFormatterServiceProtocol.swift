import Foundation

@objc public protocol SwiftFormatterServiceProtocol {
  func format(source: String, reply: @escaping (String?, Error?) -> Void)
}
