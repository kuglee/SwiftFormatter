import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

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
    VStack(alignment: .leading, spacing: .grid(2)) {
      Text("Formatting and linting rules:")
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
          ) { Text(key.separateCamelCase.sentenceCase) }
          .modifier(PrimaryToggleStyle())
          .modifier(
            AlternatingListBackgroundStyle(
              background: index % 2 == 0 ? .dark : .light
            )
          )
        }
      }
      .modifier(PrimaryListBorderStyle())
    }
  }
}

extension String {
  func replacingRegex(
      matching pattern: String,
      replacingOptions: NSRegularExpression.MatchingOptions = [],
      with template: String
  ) -> String {
      guard let regex = try? NSRegularExpression(pattern: pattern) else {
        return self
      }
    
      let range = NSRange(startIndex..., in: self)
      return regex.stringByReplacingMatches(in: self, options: replacingOptions, range: range, withTemplate: template)
  }

  var separateCamelCase: String {
    self.replacingRegex(matching: #"((?<=\p{Ll})\p{Lu}|(?<!^)\p{Lu}(?=\p{Ll}))"#, with: " $1")
  }
  
  var sentenceCase: String {
    self.split(separator: " ").map { $0 == $0.uppercased() ? String($0) : $0.lowercased()}
      .joined(separator: " ").capitalizingFirstLetter()
  }
  
  func capitalizingFirstLetter() -> String {
    self.prefix(1).capitalized + self.dropFirst()
  }
}
