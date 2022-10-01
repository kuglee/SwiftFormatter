import ComposableArchitecture
import StyleGuide
import SwiftUI

public struct FormatterRules: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    @BindableState public var doNotUseSemicolons: Bool
    @BindableState public var fileScopedDeclarationPrivacy: Bool
    @BindableState public var fullyIndirectEnum: Bool
    @BindableState public var groupNumericLiterals: Bool
    @BindableState public var noAccessLevelOnExtensionDeclaration: Bool
    @BindableState public var noCasesWithOnlyFallthrough: Bool
    @BindableState public var noEmptyTrailingClosureParentheses: Bool
    @BindableState public var noLabelsInCasePatterns: Bool
    @BindableState public var noParensAroundConditions: Bool
    @BindableState public var noVoidReturnOnFunctionSignature: Bool
    @BindableState public var oneCasePerLine: Bool
    @BindableState public var oneVariableDeclarationPerLine: Bool
    @BindableState public var orderedImports: Bool
    @BindableState public var returnVoidInsteadOfEmptyTuple: Bool
    @BindableState public var useEarlyExits: Bool
    @BindableState public var useShorthandTypeNames: Bool
    @BindableState public var useSingleLinePropertyGetter: Bool
    @BindableState public var useTripleSlashForDocumentationComments: Bool
    @BindableState public var useWhereClausesInForLoops: Bool

    public init(
      doNotUseSemicolons: Bool,
      fileScopedDeclarationPrivacy: Bool,
      fullyIndirectEnum: Bool,
      groupNumericLiterals: Bool,
      noAccessLevelOnExtensionDeclaration: Bool,
      noCasesWithOnlyFallthrough: Bool,
      noEmptyTrailingClosureParentheses: Bool,
      noLabelsInCasePatterns: Bool,
      noParensAroundConditions: Bool,
      noVoidReturnOnFunctionSignature: Bool,
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
      self.doNotUseSemicolons = doNotUseSemicolons
      self.fileScopedDeclarationPrivacy = fileScopedDeclarationPrivacy
      self.fullyIndirectEnum = fullyIndirectEnum
      self.groupNumericLiterals = groupNumericLiterals
      self.noAccessLevelOnExtensionDeclaration = noAccessLevelOnExtensionDeclaration
      self.noCasesWithOnlyFallthrough = noCasesWithOnlyFallthrough
      self.noEmptyTrailingClosureParentheses = noEmptyTrailingClosureParentheses
      self.noLabelsInCasePatterns = noLabelsInCasePatterns
      self.noParensAroundConditions = noParensAroundConditions
      self.noVoidReturnOnFunctionSignature = noVoidReturnOnFunctionSignature
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

  public var body: some ReducerProtocol<State, Action> { BindingReducer() }
}

public struct FormatterRulesView: View {
  let store: StoreOf<FormatterRules>

  public init(store: StoreOf<FormatterRules>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text("Formatting rules:")
        List {
          Toggle(isOn: viewStore.binding(\.$doNotUseSemicolons)) { Text("Do Not Use Semicolons") }
          Toggle(isOn: viewStore.binding(\.$fileScopedDeclarationPrivacy)) {
            Text("File Scoped Declaration Privacy")
          }
          Toggle(isOn: viewStore.binding(\.$fullyIndirectEnum)) { Text("Fully Indirect Enum") }
          Toggle(isOn: viewStore.binding(\.$groupNumericLiterals)) {
            Text("Group Numeric Literals")
          }
          Toggle(isOn: viewStore.binding(\.$noAccessLevelOnExtensionDeclaration)) {
            Text("No Access Level On Extension Declaration")
          }
          Toggle(isOn: viewStore.binding(\.$noCasesWithOnlyFallthrough)) {
            Text("No Cases With Only Fallthrough")
          }
          Toggle(isOn: viewStore.binding(\.$noEmptyTrailingClosureParentheses)) {
            Text("No Empty Trailing Closure Parentheses")
          }
          Toggle(isOn: viewStore.binding(\.$noLabelsInCasePatterns)) {
            Text("No Labels In Case Patterns")
          }
          Toggle(isOn: viewStore.binding(\.$noParensAroundConditions)) {
            Text("No Parens Around Conditions")
          }
          Group {
            Toggle(isOn: viewStore.binding(\.$noVoidReturnOnFunctionSignature)) {
              Text("No Void Return On Function Signature")
            }
            Toggle(isOn: viewStore.binding(\.$oneCasePerLine)) { Text("One Case Per Line") }
            Toggle(isOn: viewStore.binding(\.$oneVariableDeclarationPerLine)) {
              Text("One Variable Declaration Per Line")
            }
            Toggle(isOn: viewStore.binding(\.$orderedImports)) { Text("Ordered Imports") }
            Toggle(isOn: viewStore.binding(\.$returnVoidInsteadOfEmptyTuple)) {
              Text("Return Void Instead Of Empty Tuple")
            }
            Toggle(isOn: viewStore.binding(\.$useEarlyExits)) { Text("Use Early Exits") }
            Toggle(isOn: viewStore.binding(\.$useShorthandTypeNames)) {
              Text("Use Shorthand Type Names")
            }
            Toggle(isOn: viewStore.binding(\.$useSingleLinePropertyGetter)) {
              Text("Use Single Line Property Getter")
            }
            Toggle(isOn: viewStore.binding(\.$useTripleSlashForDocumentationComments)) {
              Text("Use Triple Slash For Documentation Comments")
            }
            Toggle(isOn: viewStore.binding(\.$useWhereClausesInForLoops)) {
              Text("Use Where Clauses In For Loops")
            }
          }
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
      }
    }
  }
}
