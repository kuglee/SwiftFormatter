import AppKit
import AppUserDefaults
import Defaults
import SwiftFormat
import XcodeKit
import os.log

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
  var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
    let bundleIdentifier = Bundle(for: type(of: self)).bundleIdentifier!

    func getCommandDefinition(for class: AnyClass, commandName: String)
      -> [XCSourceEditorCommandDefinitionKey: Any]
    {
      [
        .identifierKey: "\(bundleIdentifier).\(`class`.self)", .classNameKey: `class`.description(),
        .nameKey: commandName,
      ]
    }

    return [
      getCommandDefinition(for: FormatSourceCommand.self, commandName: "Format Source"),
      getCommandDefinition(for: OpenPreferencesCommand.self, commandName: "Settings..."),
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

    let previousSelection = invocation.buffer.selections[0] as! XCSourceTextRange
    let source =
      Defaults[.shouldTrimTrailingWhitespace]
      ? invocation.buffer.completeBufferTrimmed : invocation.buffer.completeBuffer
    var formattedSource = ""

    let formatter = SwiftFormatter(configuration: Defaults[.configuration])
    do { try formatter.format(source: source, assumingFileURL: nil, to: &formattedSource) }
    catch { os_log("Unable to format source: %{public}@", error.localizedDescription) }

    if formattedSource.isEmpty || source == formattedSource { return completionHandler(nil) }

    invocation.buffer.selections.removeAllObjects()
    invocation.buffer.completeBuffer = formattedSource
    invocation.buffer.selections.add(previousSelection)

    return completionHandler(nil)
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
