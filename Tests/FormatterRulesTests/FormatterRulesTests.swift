import ComposableArchitecture
import XCTest

@testable import FormatterRules

@MainActor final class FormatterRulesTests: XCTestCase {
  func testSetBindings() async {
    let store = TestStore(
      initialState: FormatterRules.State(
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
      ),
      reducer: FormatterRules()
    )

    await store.send(.set(\.$doNotUseSemicolons, true)) { $0.doNotUseSemicolons = true }
    await store.send(.set(\.$fileScopedDeclarationPrivacy, true)) {
      $0.fileScopedDeclarationPrivacy = true
    }
    await store.send(.set(\.$fullyIndirectEnum, true)) { $0.fullyIndirectEnum = true }
    await store.send(.set(\.$groupNumericLiterals, true)) { $0.groupNumericLiterals = true }
    await store.send(.set(\.$noAccessLevelOnExtensionDeclaration, true)) {
      $0.noAccessLevelOnExtensionDeclaration = true
    }
    await store.send(.set(\.$noCasesWithOnlyFallthrough, true)) {
      $0.noCasesWithOnlyFallthrough = true
    }
    await store.send(.set(\.$noEmptyTrailingClosureParentheses, true)) {
      $0.noEmptyTrailingClosureParentheses = true
    }
    await store.send(.set(\.$noLabelsInCasePatterns, true)) { $0.noLabelsInCasePatterns = true }
    await store.send(.set(\.$noParensAroundConditions, true)) { $0.noParensAroundConditions = true }
    await store.send(.set(\.$noVoidReturnOnFunctionSignature, true)) {
      $0.noVoidReturnOnFunctionSignature = true
    }
    await store.send(.set(\.$oneCasePerLine, true)) { $0.oneCasePerLine = true }
    await store.send(.set(\.$oneVariableDeclarationPerLine, true)) {
      $0.oneVariableDeclarationPerLine = true
    }
    await store.send(.set(\.$orderedImports, true)) { $0.orderedImports = true }
    await store.send(.set(\.$returnVoidInsteadOfEmptyTuple, true)) {
      $0.returnVoidInsteadOfEmptyTuple = true
    }
    await store.send(.set(\.$useEarlyExits, true)) { $0.useEarlyExits = true }
    await store.send(.set(\.$useShorthandTypeNames, true)) { $0.useShorthandTypeNames = true }
    await store.send(.set(\.$useSingleLinePropertyGetter, true)) {
      $0.useSingleLinePropertyGetter = true
    }
    await store.send(.set(\.$useTripleSlashForDocumentationComments, true)) {
      $0.useTripleSlashForDocumentationComments = true
    }
    await store.send(.set(\.$useWhereClausesInForLoops, true)) {
      $0.useWhereClausesInForLoops = true
    }
  }
}
