import ComposableArchitecture
import SwiftFormatConfiguration
import SwiftUI

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

public struct RulesView: View {
  @ObservedObject var store: Store<RulesViewState, RulesViewAction>

  public init(store: Store<RulesViewState, RulesViewAction>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 6) {
        ForEach(self.store.value.rules.keys.sorted(), id: \.self) { key in
          Toggle(
            isOn: Binding(
              get: { self.store.value.rules[key]! },
              set: { self.store.send(.ruleFilledOut(key: key, value: $0)) }
            )
          ) { Text(key) }
        }
      }.frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity,
        alignment: .top
      )
    }
  }
}
