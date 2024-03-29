import AppKit
import AppUserDefaults
import SwiftFormat
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

    let source =
      AppUserDefaults.live.getShouldTrimTrailingWhitespace()
      ? invocation.buffer.completeBufferTrimmed : invocation.buffer.completeBuffer
    var formattedSource = ""

    let formatter = SwiftFormatter(
      configuration: AppUserDefaults.live.getConfigurationWrapper().toConfiguration()
    )
    do { try formatter.format(source: source, assumingFileURL: nil, to: &formattedSource) } catch {
      os_log("Unable to format source: %{public}@", error.localizedDescription)
    }

    if formattedSource.isEmpty || source == formattedSource { return completionHandler(nil) }

    let previousSelection = invocation.buffer.selections[0] as! XCSourceTextRange
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
