import ComposableArchitecture
import ConfigurationWrapper
import StyleGuide
import SwiftUI

public struct FormatterRules: Reducer {
  public init() {}

  public struct State: Equatable {
    @BindingState public var alwaysUseLiteralForEmptyCollectionInit: Bool
    @BindingState public var doNotUseSemicolons: Bool
    @BindingState public var fileScopedDeclarationPrivacy: Bool
    @BindingState public var fullyIndirectEnum: Bool
    @BindingState public var groupNumericLiterals: Bool
    @BindingState public var noAccessLevelOnExtensionDeclaration: Bool
    @BindingState public var noAssignmentInExpressions: Bool
    @BindingState public var noCasesWithOnlyFallthrough: Bool
    @BindingState public var noEmptyTrailingClosureParentheses: Bool
    @BindingState public var noLabelsInCasePatterns: Bool
    @BindingState public var noParensAroundConditions: Bool
    @BindingState public var noVoidReturnOnFunctionSignature: Bool
    @BindingState public var omitExplicitReturns: Bool
    @BindingState public var oneCasePerLine: Bool
    @BindingState public var oneVariableDeclarationPerLine: Bool
    @BindingState public var orderedImports: Bool
    @BindingState public var returnVoidInsteadOfEmptyTuple: Bool
    @BindingState public var useEarlyExits: Bool
    @BindingState public var useShorthandTypeNames: Bool
    @BindingState public var useSingleLinePropertyGetter: Bool
    @BindingState public var useTripleSlashForDocumentationComments: Bool
    @BindingState public var useWhereClausesInForLoops: Bool

    public init(
      alwaysUseLiteralForEmptyCollectionInit: Bool,
      doNotUseSemicolons: Bool,
      fileScopedDeclarationPrivacy: Bool,
      fullyIndirectEnum: Bool,
      groupNumericLiterals: Bool,
      noAccessLevelOnExtensionDeclaration: Bool,
      noAssignmentInExpressions: Bool,
      noCasesWithOnlyFallthrough: Bool,
      noEmptyTrailingClosureParentheses: Bool,
      noLabelsInCasePatterns: Bool,
      noParensAroundConditions: Bool,
      noVoidReturnOnFunctionSignature: Bool,
      omitExplicitReturns: Bool,
      oneCasePerLine: Bool,
      oneVariableDeclarationPerLine: Bool,
      orderedImports: Bool,
      returnVoidInsteadOfEmptyTuple: Bool,
      useEarlyExits: Bool,
      useShorthandTypeNames: Bool,
      useSingleLinePropertyGetter: Bool,
      useTripleSlashForDocumentationComments: Bool,
      useWhereClausesInForLoops: Bool
    ) {
      self.alwaysUseLiteralForEmptyCollectionInit = alwaysUseLiteralForEmptyCollectionInit
      self.doNotUseSemicolons = doNotUseSemicolons
      self.fileScopedDeclarationPrivacy = fileScopedDeclarationPrivacy
      self.fullyIndirectEnum = fullyIndirectEnum
      self.groupNumericLiterals = groupNumericLiterals
      self.noAccessLevelOnExtensionDeclaration = noAccessLevelOnExtensionDeclaration
      self.noAssignmentInExpressions = noAssignmentInExpressions
      self.noCasesWithOnlyFallthrough = noCasesWithOnlyFallthrough
      self.noEmptyTrailingClosureParentheses = noEmptyTrailingClosureParentheses
      self.noLabelsInCasePatterns = noLabelsInCasePatterns
      self.noParensAroundConditions = noParensAroundConditions
      self.noVoidReturnOnFunctionSignature = noVoidReturnOnFunctionSignature
      self.omitExplicitReturns = omitExplicitReturns
      self.oneCasePerLine = oneCasePerLine
      self.oneVariableDeclarationPerLine = oneVariableDeclarationPerLine
      self.orderedImports = orderedImports
      self.returnVoidInsteadOfEmptyTuple = returnVoidInsteadOfEmptyTuple
      self.useEarlyExits = useEarlyExits
      self.useShorthandTypeNames = useShorthandTypeNames
      self.useSingleLinePropertyGetter = useSingleLinePropertyGetter
      self.useTripleSlashForDocumentationComments = useTripleSlashForDocumentationComments
      self.useWhereClausesInForLoops = useWhereClausesInForLoops
    }
  }

  public enum Action: Equatable, BindableAction { case binding(BindingAction<State>) }

  public var body: some ReducerOf<Self> { BindingReducer() }
}

public struct FormatterRulesView: View {
  let store: StoreOf<FormatterRules>

  public init(store: StoreOf<FormatterRules>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text("Formatting rules:")
        List {
          Toggle(isOn: viewStore.$alwaysUseLiteralForEmptyCollectionInit) {
            Text("Always use literal for empty collection init")
          }
          Toggle(isOn: viewStore.$doNotUseSemicolons) { Text("Do not use semicolons") }
          Toggle(isOn: viewStore.$fileScopedDeclarationPrivacy) {
            Text("File-scoped declaration privacy")
          }
          Toggle(isOn: viewStore.$fullyIndirectEnum) { Text("Fully indirect enum") }
          Toggle(isOn: viewStore.$groupNumericLiterals) { Text("Group numeric literals") }
          Toggle(isOn: viewStore.$noAccessLevelOnExtensionDeclaration) {
            Text("No access level on extension declaration")
          }
          Toggle(isOn: viewStore.$noAssignmentInExpressions) {
            Text("No assignment in expressions")
          }
          Toggle(isOn: viewStore.$noCasesWithOnlyFallthrough) {
            Text("No cases with only fallthrough")
          }
          Toggle(isOn: viewStore.$noEmptyTrailingClosureParentheses) {
            Text("No empty trailing closure parentheses")
          }
          Toggle(isOn: viewStore.$noLabelsInCasePatterns) { Text("No labels in case patterns") }
          Toggle(isOn: viewStore.$noParensAroundConditions) { Text("No parens around conditions") }
          Toggle(isOn: viewStore.$noVoidReturnOnFunctionSignature) {
            Text("No Void return on function signature")
          }
          Toggle(isOn: viewStore.$omitExplicitReturns) { Text("Omit explicit returns") }
          Toggle(isOn: viewStore.$oneCasePerLine) { Text("One case per line") }
          Toggle(isOn: viewStore.$oneVariableDeclarationPerLine) {
            Text("One variable declaration per line")
          }
          Toggle(isOn: viewStore.$orderedImports) { Text("Ordered imports") }
          Toggle(isOn: viewStore.$returnVoidInsteadOfEmptyTuple) {
            Text("Return Void instead of empty tuple")
          }
          Toggle(isOn: viewStore.$useEarlyExits) { Text("Use early exits") }
          Toggle(isOn: viewStore.$useShorthandTypeNames) { Text("Use shorthand type names") }
          Toggle(isOn: viewStore.$useSingleLinePropertyGetter) {
            Text("Use single line property getter")
          }
          Toggle(isOn: viewStore.$useTripleSlashForDocumentationComments) {
            Text("Use triple slash for documentation comments")
          }
          Toggle(isOn: viewStore.$useWhereClausesInForLoops) {
            Text("Use where clauses in for loops")
          }
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
      }
    }
  }
}
