import Foundation

@objc protocol SwiftFormatterServiceProtocol {
  func format(source: String, reply: @escaping (String?, Error?) -> Void)
}
