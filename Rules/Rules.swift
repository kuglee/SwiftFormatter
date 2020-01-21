import ComposableArchitecture
import StyleGuide
import SwiftUI

extension Bundle {
  static var current: Bundle {
    class __ {}
    return Bundle(for: __.self)
  }
}

public enum RulesViewAction: Equatable {
  case ruleFilledOut(key: String, value: Bool)
}

public struct RulesViewState {
  public var rules: [String: Bool]

  public init(rules: [String: Bool]) { self.rules = rules }
}

public func rulesViewReducer(
  state: inout RulesViewState,
  action: RulesViewAction
) -> [Effect<RulesViewAction>] {
  switch action {
  case .ruleFilledOut(let key, let value):
    state.rules[key] = value
    return []
  }
}

extension StringProtocol {
  var firstCapitalized: String { prefix(1).capitalized + dropFirst() }

  func camelCaseToWords() -> String {
    unicodeScalars.reduce("") {
      if CharacterSet.uppercaseLetters.contains($1) {
        if $0.count > 0 { return ($0 + " " + String($1)) }
      }

      return $0 + String($1)
    }
  }
}

extension Collection {
  func enumeratedArray() -> [(offset: Int, element: Self.Element)] {
    return Array(self.enumerated())
  }
}

public struct RulesView: View {
  @ObservedObject var store: Store<RulesViewState, RulesViewAction>

  public init(store: Store<RulesViewState, RulesViewAction>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("Linter rules:", bundle: Bundle.current)
      List {
        ForEach(
          self.store.value.rules.keys.sorted().enumeratedArray(),
          id: \.offset
        ) { index, key in
          Toggle(
            isOn: Binding(
              get: { self.store.value.rules[key]! },
              set: { self.store.send(.ruleFilledOut(key: key, value: $0)) }
            )
          ) { Text(LocalizedStringKey(key), bundle: Bundle.current) }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
          ).modifier(
            AlternatingListBackgroundStyle(
              background: index % 2 == 0 ? .dark : .light
            )
          )
        }
      }.modifier(PrimaryListBorderStyle())
    }
  }
}
