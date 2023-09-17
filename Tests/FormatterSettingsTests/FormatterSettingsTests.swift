import ComposableArchitecture
import SwiftFormatConfiguration
import XCTest

@testable import FormatterSettings

@MainActor final class FormatterSettingsTests: XCTestCase {
  func testSetBindings() async {
    let store = TestStore(
      initialState: FormatterSettings.State(
        shouldTrimTrailingWhitespace: false,
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
        lineBreakAroundMultilineExpressionChainComponents: false,
        indentSwitchCaseLabels: false,
        fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration(),
        spacesAroundRangeFormationOperators: false,
        noAssignmentInExpressions: NoAssignmentInExpressionsConfiguration(),
        multiElementCollectionTrailingCommas: false
      ),
      reducer: { FormatterSettings() }
    )

    await store.send(.set(\.$shouldTrimTrailingWhitespace, true)) {
      $0.shouldTrimTrailingWhitespace = true
    }
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
    await store.send(.set(\.$lineBreakAroundMultilineExpressionChainComponents, true)) {
      $0.lineBreakAroundMultilineExpressionChainComponents = true
    }
    await store.send(.set(\.$indentSwitchCaseLabels, true)) { $0.indentSwitchCaseLabels = true }
    await store.send(
      .set(
        \.$fileScopedDeclarationPrivacy,
        {
          var fileScopedDeclarationPrivacyConfiguration =
            FileScopedDeclarationPrivacyConfiguration()
          fileScopedDeclarationPrivacyConfiguration.accessLevel = .fileprivate

          return fileScopedDeclarationPrivacyConfiguration
        }()
      )
    ) {
      $0.fileScopedDeclarationPrivacy = {
        var fileScopedDeclarationPrivacyConfiguration = FileScopedDeclarationPrivacyConfiguration()
        fileScopedDeclarationPrivacyConfiguration.accessLevel = .fileprivate

        return fileScopedDeclarationPrivacyConfiguration
      }()
    }
    await store.send(.set(\.$spacesAroundRangeFormationOperators, true)) {
      $0.spacesAroundRangeFormationOperators = true
    }
    await store.send(.set(\.$noAssignmentInExpressionsText, "test1,\t    test2    ")) {
      $0.noAssignmentInExpressionsText = "test1,\t    test2    "
      $0.noAssignmentInExpressions.allowedFunctions = ["test1", "test2"]
    }
    await store.send(.set(\.$multiElementCollectionTrailingCommas, true)) {
      $0.multiElementCollectionTrailingCommas = true
    }
  }
}
