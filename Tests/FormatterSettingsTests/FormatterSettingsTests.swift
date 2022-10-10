import ComposableArchitecture
import XCTest

@testable import FormatterSettings
// @testable because FileScopedDeclarationPrivacyConfiguration doesn't have a public initializer
@testable import SwiftFormatConfiguration

@MainActor final class FormatterSettingsTests: XCTestCase {
  func testSetBindings() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        maximumBlankLines: 0,
        lineLength: 0,
        tabWidth: 0,
        indentation: Indent.spaces(0),
        respectsExistingLineBreaks: false,
        lineBreakBeforeControlFlowKeywords: false,
        lineBreakBeforeEachArgument: false,
        lineBreakBeforeEachGenericRequirement: false,
        prioritizeKeepingFunctionOutputTogether: false,
        indentConditionalCompilationBlocks: false,
        indentSwitchCaseLabels: false,
        lineBreakAroundMultilineExpressionChainComponents: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        shouldTrimTrailingWhitespace: false
      ),
      reducer: FormatterSettings()
    )

    await store.send(.set(\.$maximumBlankLines, 1)) { $0.maximumBlankLines = 1 }
    await store.send(.set(\.$lineLength, 1)) { $0.lineLength = 1 }
    await store.send(.set(\.$tabWidth, 1)) { $0.tabWidth = 1 }
    await store.send(.set(\.$indentation, .spaces(1))) { $0.indentation = .spaces(1) }
    await store.send(.set(\.$indentation, .spaces(2))) { $0.indentation = .spaces(2) }
    await store.send(.set(\.$indentation, .tabs(2))) { $0.indentation = .tabs(2) }
    await store.send(.set(\.$respectsExistingLineBreaks, true)) {
      $0.respectsExistingLineBreaks = true
    }
    await store.send(.set(\.$lineBreakBeforeControlFlowKeywords, true)) {
      $0.lineBreakBeforeControlFlowKeywords = true
    }
    await store.send(.set(\.$lineBreakBeforeEachArgument, true)) {
      $0.lineBreakBeforeEachArgument = true
    }
    await store.send(.set(\.$lineBreakBeforeEachGenericRequirement, true)) {
      $0.lineBreakBeforeEachGenericRequirement = true
    }
    await store.send(.set(\.$prioritizeKeepingFunctionOutputTogether, true)) {
      $0.prioritizeKeepingFunctionOutputTogether = true
    }
    await store.send(.set(\.$indentConditionalCompilationBlocks, true)) {
      $0.indentConditionalCompilationBlocks = true
    }
    await store.send(.set(\.$indentSwitchCaseLabels, true)) { $0.indentSwitchCaseLabels = true }
    await store.send(.set(\.$lineBreakAroundMultilineExpressionChainComponents, true)) {
      $0.lineBreakAroundMultilineExpressionChainComponents = true
    }
    await store.send(
      .set(
        \.$fileScopedDeclarationPrivacy,
        FileScopedDeclarationPrivacyConfiguration(accessLevel: .fileprivate)
      )
    ) {
      $0.fileScopedDeclarationPrivacy = FileScopedDeclarationPrivacyConfiguration(
        accessLevel: .fileprivate
      )
    }
    await store.send(.set(\.$shouldTrimTrailingWhitespace, true)) {
      $0.shouldTrimTrailingWhitespace = true
    }
  }
}