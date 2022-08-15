import ComposableArchitecture
import StyleGuide
import SwiftUI

public enum FormatterRulesViewAction: Equatable { case ruleFilledOut(key: String, value: Bool) }

public struct FormatterRulesViewState: Equatable {
  public var rules: [String: Bool]

  public init(rules: [String: Bool]) { self.rules = rules }
}

public let formatterRulesViewReducer = Reducer<
  FormatterRulesViewState, FormatterRulesViewAction, Void
> { state, action, _ in
  switch action {
  case .ruleFilledOut(let key, let value):
    state.rules[key] = value
    return .none
  }
}

public struct FormatterRulesView: View {
  let store: Store<FormatterRulesViewState, FormatterRulesViewAction>

  public init(store: Store<FormatterRulesViewState, FormatterRulesViewAction>) {
    self.store = store
  }

  var colors: [Color] = [.red, .blue, .yellow]
  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text("Formatting rules:")
        List(viewStore.rules.keys.sorted().enumeratedArray(), id: \.offset) { index, key in
          Toggle(
            isOn: Binding(
              get: { viewStore.rules[key]! },
              set: { viewStore.send(.ruleFilledOut(key: key, value: $0)) }
            )
          ) {
            Text(splitCamelCase(string: key).joined(separator: " ").sentenceCased(separator: " "))
          }
        }
        .listStyle(.bordered(alternatesRowBackgrounds: true))
      }
    }
  }
}

func splitCamelCase(string s: String) -> [String.SubSequence] {
  s.replacingRegex(matching: #"((?<=\p{Ll})\p{Lu}|(?<!^)\p{Lu}(?=\p{Ll}))"#, with: " $1")
    .split(separator: " ")
}

extension String {
  func replacingRegex(
    matching pattern: String,
    replacingOptions: NSRegularExpression.MatchingOptions = [],
    with template: String
  ) -> Self {
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return self }

    let range = NSRange(startIndex..., in: self)

    return regex.stringByReplacingMatches(
      in: self,
      options: replacingOptions,
      range: range,
      withTemplate: template
    )
  }

  func sentenceCased(separator: Self.Element) -> Self {
    self.split(separator: separator).map { $0 == $0.uppercased() ? String($0) : $0.lowercased() }
      .joined(separator: String(separator)).capitalizingFirstLetter()
  }

  func capitalizingFirstLetter() -> String { self.prefix(1).capitalized + self.dropFirst() }
}

extension Collection {
  public func enumeratedArray() -> [(offset: Int, element: Self.Element)] {
    Array(self.enumerated())
  }
}
