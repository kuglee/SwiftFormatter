import Foundation
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

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
  func perform(
    with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void
  ) {
    guard
      ["public.swift-source", "com.apple.dt.playground", "com.apple.dt.playgroundpage"].contains(
        invocation.buffer.contentUTI)
    else { return completionHandler(FormatterError.notSwiftSource) }

    let swiftFormatServiceConnection = NSXPCConnection(
      serviceName: "com.kuglee.swift-format.service")
    swiftFormatServiceConnection.remoteObjectInterface = NSXPCInterface(
      with: SwiftFormatServiceProtocol.self)
    swiftFormatServiceConnection.resume()

    let swiftFormatService =
      (swiftFormatServiceConnection.remoteObjectProxy as AnyObject)
      .remoteObjectProxyWithErrorHandler { error in os_log("%{public}@", error.localizedDescription)
      } as! SwiftFormatServiceProtocol

    let previousSelection = invocation.buffer.selections[0] as! XCSourceTextRange
    let source = invocation.buffer.completeBuffer

    swiftFormatService.format(source: source) { formattedSource, error in
      defer { swiftFormatServiceConnection.invalidate() }

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
