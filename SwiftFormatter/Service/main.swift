import Foundation

class ServiceDelegate: NSObject, NSXPCListenerDelegate {
  func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection)
    -> Bool
  {
    newConnection.exportedInterface = NSXPCInterface(with: SwiftFormatterServiceProtocol.self)
    newConnection.exportedObject = SwiftFormatterService()
    newConnection.resume()

    return true
  }
}

let delegate = ServiceDelegate()

let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
