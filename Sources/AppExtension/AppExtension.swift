import AppConstants
import AppKit
import AppUserDefaults
import SwiftFormatterServiceProtocol
import XcodeKit
import os.log

open class AppExtension: NSObject, XCSourceEditorExtension {
  public var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
    [
      makeCommandDefinition(name: "Format Source", class: FormatSourceCommand.self),
      makeCommandDefinition(name: "Settings...", class: OpenPreferencesCommand.self),
    ]
  }

  func makeCommandDefinition(name: String, class: AnyClass) -> [XCSourceEditorCommandDefinitionKey:
    String]
  {
    [
      .identifierKey: "\(Bundle.main.bundleIdentifier!).\(`class`.self)",
      .classNameKey: `class`.description(), .nameKey: name,
    ]
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

    let serviceConnection = getServiceConnection()
    serviceConnection.resume()

    let service = getService(connection: serviceConnection)

    let source =
      AppUserDefaults.live.getShouldTrimTrailingWhitespace()
      ? invocation.buffer.completeBufferTrimmed : invocation.buffer.completeBuffer

    service.format(source: source) { formattedSource, error in
      defer { serviceConnection.invalidate() }

      if let _ = error { return completionHandler(nil) }

      guard let formattedSource = formattedSource else { return completionHandler(nil) }

      if source == formattedSource { return completionHandler(nil) }

      let previousSelection = invocation.buffer.selections[0] as! XCSourceTextRange
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
  return (connection.remoteObjectProxy as! NSXPCProxyCreating)
    .remoteObjectProxyWithErrorHandler { error in os_log("%{public}@", error.localizedDescription) }
    as! SwiftFormatterServiceProtocol
}
