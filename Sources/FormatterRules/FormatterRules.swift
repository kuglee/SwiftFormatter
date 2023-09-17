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
            Text("Always Use Literal For Empty Collection Init")
          }
          Toggle(isOn: viewStore.$doNotUseSemicolons) { Text("Do Not Use Semicolons") }
          Toggle(isOn: viewStore.$fileScopedDeclarationPrivacy) {
            Text("File Scoped Declaration Privacy")
          }
          Toggle(isOn: viewStore.$fullyIndirectEnum) { Text("Fully Indirect Enum") }
          Toggle(isOn: viewStore.$groupNumericLiterals) { Text("Group Numeric Literals") }
          Toggle(isOn: viewStore.$noAccessLevelOnExtensionDeclaration) {
            Text("No Access Level On Extension Declaration")
          }
          Toggle(isOn: viewStore.$noAssignmentInExpressions) {
            Text("No Assignment In Expressions")
          }
          Toggle(isOn: viewStore.$noCasesWithOnlyFallthrough) {
            Text("No Cases With Only Fallthrough")
          }
          Toggle(isOn: viewStore.$noEmptyTrailingClosureParentheses) {
            Text("No Empty Trailing Closure Parentheses")
          }
          Toggle(isOn: viewStore.$noLabelsInCasePatterns) { Text("No Labels In Case Patterns") }
          Toggle(isOn: viewStore.$noParensAroundConditions) { Text("No Parens Around Conditions") }
          Toggle(isOn: viewStore.$noVoidReturnOnFunctionSignature) {
            Text("No Void Return On Function Signature")
          }
          Toggle(isOn: viewStore.$omitExplicitReturns) { Text("Omit Explicit Returns") }
          Toggle(isOn: viewStore.$oneCasePerLine) { Text("One Case Per Line") }
          Toggle(isOn: viewStore.$oneVariableDeclarationPerLine) {
            Text("One Variable Declaration Per Line")
          }
          Toggle(isOn: viewStore.$orderedImports) { Text("Ordered Imports") }
          Toggle(isOn: viewStore.$returnVoidInsteadOfEmptyTuple) {
            Text("Return Void Instead Of Empty Tuple")
          }
          Toggle(isOn: viewStore.$useEarlyExits) { Text("Use Early Exits") }
          Toggle(isOn: viewStore.$useShorthandTypeNames) { Text("Use Shorthand Type Names") }
          Toggle(isOn: viewStore.$useSingleLinePropertyGetter) {
            Text("Use Single Line Property Getter")
          }
          Toggle(isOn: viewStore.$useTripleSlashForDocumentationComments) {
            Text("Use Triple Slash For Documentation Comments")
          }
          Toggle(isOn: viewStore.$useWhereClausesInForLoops) {
            Text("Use Where Clauses In For Loops")
          }
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
      }
    }
  }
}
