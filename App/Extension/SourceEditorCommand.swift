import AppConstants
import AppKit
import ConfigurationManager
import SwiftFormatterServiceProtocol
import XcodeKit
import os.log

enum FormatterError: Error, LocalizedError {
  case formatError

  var localizedDescription: String {
    switch self {
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
    else { return completionHandler(nil) }

    let previousSelection = invocation.buffer.selections[0] as! XCSourceTextRange
    let source =
      getShouldTrimTrailingWhitespace()
      ? invocation.buffer.completeBufferTrimmed : invocation.buffer.completeBuffer

    let serviceConnection = getServiceConnection()
    serviceConnection.resume()

    let service = getService(connection: serviceConnection)

    service.format(source: source) { formattedSource, error in
      defer { serviceConnection.invalidate() }

      // can't show any error message, so don't return errors
      guard let formattedSource = formattedSource, error == nil else {
        return completionHandler(nil)
      }

      if source == formattedSource { return completionHandler(nil) }

      invocation.buffer.selections.removeAllObjects()
      invocation.buffer.completeBuffer = formattedSource
      invocation.buffer.selections.add(previousSelection)

      return completionHandler(nil)
    }
  }
}

class OpenPreferencesCommand: NSObject, XCSourceEditorCommand {
  func perform(
    with invocation: XCSourceEditorCommandInvocation,
    completionHandler: @escaping (Error?) -> Void
  ) {
    NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Swift Formatter.app"))

    return completionHandler(nil)
  }
}

extension XCSourceTextBuffer {
  var completeBufferTrimmed: String {
    lines.map { ($0 as! String).trailingWhitespaceTrimmed + "\n" }.joined()
  }
}

extension StringProtocol {
  @inline(__always) var trailingWhitespaceTrimmed: Self.SubSequence {
    var view = self[...]

    while view.last?.isWhitespace == true { view = view.dropLast() }

    return view
  }
}

func getServiceConnection() -> NSXPCConnection {
  let connection = NSXPCConnection(serviceName: AppConstants.xpcServiceName)
  connection.remoteObjectInterface = NSXPCInterface(with: SwiftFormatterServiceProtocol.self)

  return connection
}

func getService(connection: NSXPCConnection) -> SwiftFormatterServiceProtocol {
  (connection.remoteObjectProxy as AnyObject)
    .remoteObjectProxyWithErrorHandler { error in os_log("%{public}@", error.localizedDescription) }
    as! SwiftFormatterServiceProtocol
}
