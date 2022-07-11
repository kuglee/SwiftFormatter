import AppConstants
import AppKit
import ConfigurationManager
import Foundation
import SwiftFormat
import SwiftFormatConfiguration
import XcodeKit

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

    let previousSelection = invocation.buffer.selections[0] as! XCSourceTextRange
    let source = invocation.buffer.completeBuffer
    var formattedSource = ""

    let formatter = SwiftFormatter(configuration: loadConfiguration(fromJSON: getConfiguration()))
    do { try formatter.format(source: source, assumingFileURL: nil, to: &formattedSource) }
    catch { return completionHandler(error) }

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
