import Foundation

@objc protocol SwiftFormatterServiceProtocol {
  func format(source: String, useAutodiscovery: Bool, reply: @escaping (String?, Error?) -> Void)
}
