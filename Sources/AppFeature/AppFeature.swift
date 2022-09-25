import ComposableArchitecture
import Settings
import SwiftFormatConfiguration
import SwiftUI

let formatterRulesKeys: [String] = [
  "DoNotUseSemicolons", "FileScopedDeclarationPrivacy", "FullyIndirectEnum", "GroupNumericLiterals",
  "NoAccessLevelOnExtensionDeclaration", "NoCasesWithOnlyFallthrough",
  "NoEmptyTrailingClosureParentheses", "NoLabelsInCasePatterns", "NoParensAroundConditions",
  "NoVoidReturnOnFunctionSignature", "OneCasePerLine", "OneVariableDeclarationPerLine",
  "OrderedImports", "ReturnVoidInsteadOfEmptyTuple", "UseEarlyExits", "UseShorthandTypeNames",
  "UseSingleLinePropertyGetter", "UseTripleSlashForDocumentationComments",
  "UseWhereClausesInForLoops",
]

public struct AppFeature: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    public var configuration: Configuration
    public var selectedTab: Tab = .formatting
    public var didRunBefore: Bool
    public var shouldTrimTrailingWhitespace: Bool

    public init(
      configuration: Configuration,
      didRunBefore: Bool,
      shouldTrimTrailingWhitespace: Bool
    ) {
      self.didRunBefore = didRunBefore
      self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
      self.configuration = configuration

      self.configuration.rules = Configuration().rules
        .filter { formatterRulesKeys.contains($0.key) }

      for rule in self.configuration.rules {
        if self.configuration.rules[rule.key] != nil {
          self.configuration.rules[rule.key] = rule.value
        }
      }
    }
  }

  public enum Action {
    case setDidRunBefore
    case settingsFeature(action: SettingsFeature.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .setDidRunBefore:
        state.didRunBefore = true
        return .none
      case .settingsFeature(_): return .none
      }
    }
    Scope(state: \.settingsFeature, action: /Action.settingsFeature(action:)) { SettingsFeature() }
  }
}

extension AppFeature.State {
  var settingsFeature: SettingsFeature.State {
    get {
      SettingsFeature.State(
        configuration: self.configuration,
        shouldTrimTrailingWhitespace: self.shouldTrimTrailingWhitespace,
        selectedTab: self.selectedTab
      )
    }
    set {
      self.configuration = newValue.configuration
      self.shouldTrimTrailingWhitespace = newValue.shouldTrimTrailingWhitespace
      self.selectedTab = newValue.selectedTab
    }
  }
}

func appViewBody(store: StoreOf<AppFeature>) -> some View {
  SettingsView(
    store: store.scope(state: \.settingsFeature, action: AppFeature.Action.settingsFeature)
  )
}

@available(macOS 13.0, *) public struct AppViewMacOS13: View {
  let store: StoreOf<AppFeature>
  @Environment(\.openWindow) private var openWindow

  public init(store: StoreOf<AppFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      appViewBody(store: self.store)
        .task {
          if !viewStore.didRunBefore {
            viewStore.send(.setDidRunBefore)
            try? await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
            openWindow(id: "welcome")
          }
        }
    }
  }
}

public struct AppViewMacOS12: View {
  let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in appViewBody(store: store) }
  }
}
