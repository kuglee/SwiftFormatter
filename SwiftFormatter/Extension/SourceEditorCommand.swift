import Foundation
import SwiftFormatterServiceProtocol
import XcodeKit
import os.log

enum FormatterError: Error, LocalizedError {
  case notSwiftSource
  case formatError

  var localizedDescription: String {
    switch self {
    case .notSwiftSource: return "Error: not a Swift source file."
    case .formatError: return "Error: could not format source file."
    }
  }
}

class FormatSourceCommand: NSObject, XCSourceEditorCommand {
  func perform(
    with invocation: XCSourceEditorCommandInvocation,
    completionHandler: @escaping (Error?) -> Void
  ) {
    guard
      ["public.swift-source", "com.apple.dt.playground", "com.apple.dt.playgroundpage"]
        .contains(invocation.buffer.contentUTI)
    else { return completionHandler(FormatterError.notSwiftSource) }

    let serviceConnection = getServiceConnection()
    serviceConnection.resume()

    let service = getService(connection: serviceConnection)

    let previousSelection = invocation.buffer.selections[0] as! XCSourceTextRange
    let source = invocation.buffer.completeBuffer

    let useConfigurationAutodiscovery = UserDefaults(suiteName: "group.com.kuglee.SwiftFormatter")!
      .bool(forKey: "useConfigurationAutodiscovery")

    service.format(source: source, useConfigurationAutodiscovery: useConfigurationAutodiscovery) {
      formattedSource,
      error in defer { serviceConnection.invalidate() }

      if let error = error { return completionHandler(error) }

      guard let formattedSource = formattedSource else {
        return completionHandler(FormatterError.formatError)
      }

      if source == formattedSource { return completionHandler(nil) }

      invocation.buffer.selections.removeAllObjects()
      invocation.buffer.completeBuffer = formattedSource
      invocation.buffer.selections.add(previousSelection)

      return completionHandler(nil)
    }
  }
}

func getServiceConnection() -> NSXPCConnection {
  let connection = NSXPCConnection(serviceName: "com.kuglee.SwiftFormatter.service")
  connection.remoteObjectInterface = NSXPCInterface(with: SwiftFormatterServiceProtocol.self)

  return connection
}

func getService(connection: NSXPCConnection) -> SwiftFormatterServiceProtocol {
  return (connection.remoteObjectProxy as AnyObject)
    .remoteObjectProxyWithErrorHandler { error in os_log("%{public}@", error.localizedDescription) }
    as! SwiftFormatterServiceProtocol
}
