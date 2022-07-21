import Foundation

let delegate = SwiftFormatterServiceDelegate()

let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
