import Foundation

@objc protocol SwiftFormatServiceProtocol {
  func format(source: String, reply: @escaping (String?, Error?) -> Void)
}
