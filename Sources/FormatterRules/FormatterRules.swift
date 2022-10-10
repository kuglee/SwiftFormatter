import ComposableArchitecture
import ConfigurationWrapper
import StyleGuide
import SwiftUI

public struct FormatterRules: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    @BindableState public var rules: ConfigurationWrapper.Rules

    public init(rules: ConfigurationWrapper.Rules) { self.rules = rules }
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
          Toggle(isOn: viewStore.binding(\.$rules.doNotUseSemicolons)) {
            Text("Do Not Use Semicolons")
          }
          Toggle(isOn: viewStore.binding(\.$rules.fileScopedDeclarationPrivacy)) {
            Text("File Scoped Declaration Privacy")
          }
          Toggle(isOn: viewStore.binding(\.$rules.fullyIndirectEnum)) {
            Text("Fully Indirect Enum")
          }
          Toggle(isOn: viewStore.binding(\.$rules.groupNumericLiterals)) {
            Text("Group Numeric Literals")
          }
          Toggle(isOn: viewStore.binding(\.$rules.noAccessLevelOnExtensionDeclaration)) {
            Text("No Access Level On Extension Declaration")
          }
          Toggle(isOn: viewStore.binding(\.$rules.noCasesWithOnlyFallthrough)) {
            Text("No Cases With Only Fallthrough")
          }
          Toggle(isOn: viewStore.binding(\.$rules.noEmptyTrailingClosureParentheses)) {
            Text("No Empty Trailing Closure Parentheses")
          }
          Toggle(isOn: viewStore.binding(\.$rules.noLabelsInCasePatterns)) {
            Text("No Labels In Case Patterns")
          }
          Toggle(isOn: viewStore.binding(\.$rules.noParensAroundConditions)) {
            Text("No Parens Around Conditions")
          }
          Group {
            Toggle(isOn: viewStore.binding(\.$rules.noVoidReturnOnFunctionSignature)) {
              Text("No Void Return On Function Signature")
            }
            Toggle(isOn: viewStore.binding(\.$rules.oneCasePerLine)) { Text("One Case Per Line") }
            Toggle(isOn: viewStore.binding(\.$rules.oneVariableDeclarationPerLine)) {
              Text("One Variable Declaration Per Line")
            }
            Toggle(isOn: viewStore.binding(\.$rules.orderedImports)) { Text("Ordered Imports") }
            Toggle(isOn: viewStore.binding(\.$rules.returnVoidInsteadOfEmptyTuple)) {
              Text("Return Void Instead Of Empty Tuple")
            }
            Toggle(isOn: viewStore.binding(\.$rules.useEarlyExits)) { Text("Use Early Exits") }
            Toggle(isOn: viewStore.binding(\.$rules.useShorthandTypeNames)) {
              Text("Use Shorthand Type Names")
            }
            Toggle(isOn: viewStore.binding(\.$rules.useSingleLinePropertyGetter)) {
              Text("Use Single Line Property Getter")
            }
            Toggle(isOn: viewStore.binding(\.$rules.useTripleSlashForDocumentationComments)) {
              Text("Use Triple Slash For Documentation Comments")
            }
            Toggle(isOn: viewStore.binding(\.$rules.useWhereClausesInForLoops)) {
              Text("Use Where Clauses In For Loops")
            }
          }
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
      }
    }
  }
}
