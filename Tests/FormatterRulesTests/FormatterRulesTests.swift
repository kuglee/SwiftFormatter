import ComposableArchitecture
import ConfigurationWrapper
import XCTest

@testable import FormatterRules

@MainActor final class FormatterRulesTests: XCTestCase {
  func testSetBindings() async {
    let store = TestStore(
      initialState: FormatterRules.State(
        rules: ConfigurationWrapper.Rules(
          doNotUseSemicolons: false,
          fileScopedDeclarationPrivacy: false,
          fullyIndirectEnum: false,
          groupNumericLiterals: false,
          noAccessLevelOnExtensionDeclaration: false,
          noCasesWithOnlyFallthrough: false,
          noEmptyTrailingClosureParentheses: false,
          noLabelsInCasePatterns: false,
          noParensAroundConditions: false,
          noVoidReturnOnFunctionSignature: false,
          oneCasePerLine: false,
          oneVariableDeclarationPerLine: false,
          orderedImports: false,
          returnVoidInsteadOfEmptyTuple: false,
          useEarlyExits: false,
          useShorthandTypeNames: false,
          useSingleLinePropertyGetter: false,
          useTripleSlashForDocumentationComments: false,
          useWhereClausesInForLoops: false
        )
      ),
      reducer: FormatterRules()
    )

    await store.send(.set(\.$rules.doNotUseSemicolons, true)) { $0.rules.doNotUseSemicolons = true }
    await store.send(.set(\.$rules.fileScopedDeclarationPrivacy, true)) {
      $0.rules.fileScopedDeclarationPrivacy = true
    }
    await store.send(.set(\.$rules.fullyIndirectEnum, true)) { $0.rules.fullyIndirectEnum = true }
    await store.send(.set(\.$rules.groupNumericLiterals, true)) { $0.rules.groupNumericLiterals = true }
    await store.send(.set(\.$rules.noAccessLevelOnExtensionDeclaration, true)) {
      $0.rules.noAccessLevelOnExtensionDeclaration = true
    }
    await store.send(.set(\.$rules.noCasesWithOnlyFallthrough, true)) {
      $0.rules.noCasesWithOnlyFallthrough = true
    }
    await store.send(.set(\.$rules.noEmptyTrailingClosureParentheses, true)) {
      $0.rules.noEmptyTrailingClosureParentheses = true
    }
    await store.send(.set(\.$rules.noLabelsInCasePatterns, true)) {
      $0.rules.noLabelsInCasePatterns = true
    }
    await store.send(.set(\.$rules.noParensAroundConditions, true)) {
      $0.rules.noParensAroundConditions = true
    }
    await store.send(.set(\.$rules.noVoidReturnOnFunctionSignature, true)) {
      $0.rules.noVoidReturnOnFunctionSignature = true
    }
    await store.send(.set(\.$rules.oneCasePerLine, true)) { $0.rules.oneCasePerLine = true }
    await store.send(.set(\.$rules.oneVariableDeclarationPerLine, true)) {
      $0.rules.oneVariableDeclarationPerLine = true
    }
    await store.send(.set(\.$rules.orderedImports, true)) { $0.rules.orderedImports = true }
    await store.send(.set(\.$rules.returnVoidInsteadOfEmptyTuple, true)) {
      $0.rules.returnVoidInsteadOfEmptyTuple = true
    }
    await store.send(.set(\.$rules.useEarlyExits, true)) { $0.rules.useEarlyExits = true }
    await store.send(.set(\.$rules.useShorthandTypeNames, true)) { $0.rules.useShorthandTypeNames = true }
    await store.send(.set(\.$rules.useSingleLinePropertyGetter, true)) {
      $0.rules.useSingleLinePropertyGetter = true
    }
    await store.send(.set(\.$rules.useTripleSlashForDocumentationComments, true)) {
      $0.rules.useTripleSlashForDocumentationComments = true
    }
    await store.send(.set(\.$rules.useWhereClausesInForLoops, true)) {
      $0.rules.useWhereClausesInForLoops = true
    }
  }
}
