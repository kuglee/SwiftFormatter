import Foundation
import SwiftFormatterServiceProtocol

class SwiftFormatterServiceDelegate: NSObject, NSXPCListenerDelegate {
  func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection)
    -> Bool
  {
    newConnection.exportedInterface = NSXPCInterface(with: SwiftFormatterServiceProtocol.self)
    newConnection.exportedObject = SwiftFormatterService()
    newConnection.resume()

    return true
  }
}
