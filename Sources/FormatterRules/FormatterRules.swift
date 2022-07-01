import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

public enum FormatterRulesViewAction: Equatable { case ruleFilledOut(key: String, value: Bool) }

public struct FormatterRulesViewState: Equatable {
  public var rules: [String: Bool]

  public init(rules: [String: Bool]) { self.rules = rules }
}

public let formatterRulesViewReducer = Reducer<FormatterRulesViewState, FormatterRulesViewAction, Void> { state, action, _ in
  switch action {
  case .ruleFilledOut(let key, let value):
    state.rules[key] = value
    return .none
  }
}

public struct FormatterRulesView: View {
  let store: Store<FormatterRulesViewState, FormatterRulesViewAction>

  public init(store: Store<FormatterRulesViewState, FormatterRulesViewAction>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading, spacing: .grid(2)) {
        Text("Formatting rules:")
        VStack(spacing: 0) {
          ForEach(viewStore.rules.keys.sorted().enumeratedArray(), id: \.offset) { index, key in
            Toggle(
              isOn: Binding(
                get: { viewStore.rules[key]! },
                set: { viewStore.send(.ruleFilledOut(key: key, value: $0)) }
              )
            ) { Text(key.separateCamelCase.sentenceCase) }
            .modifier(PrimaryToggleStyle())
            .modifier(AlternatingContentBackground(background: index % 2 == 0 ? .dark : .light))
          }
        }
        .modifier(PrimaryListBorderStyle())
      }
    }
  }
}

extension String {
  func replacingRegex(
    matching pattern: String,
    replacingOptions: NSRegularExpression.MatchingOptions = [],
    with template: String
  ) -> String {
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return self }

    let range = NSRange(startIndex..., in: self)

    return regex.stringByReplacingMatches(
      in: self,
      options: replacingOptions,
      range: range,
      withTemplate: template
    )
  }

  var separateCamelCase: String {
    self.replacingRegex(matching: #"((?<=\p{Ll})\p{Lu}|(?<!^)\p{Lu}(?=\p{Ll}))"#, with: " $1")
  }

  var sentenceCase: String {
    self.split(separator: " ").map { $0 == $0.uppercased() ? String($0) : $0.lowercased() }
      .joined(separator: " ").capitalizingFirstLetter()
  }

  func capitalizingFirstLetter() -> String { self.prefix(1).capitalized + self.dropFirst() }
}