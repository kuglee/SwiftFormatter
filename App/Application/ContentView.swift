import CasePaths
import ComposableArchitecture
import ConfigurationManager
import Settings
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import Utility

let formatterRulesKeys: [String] = [
  "DoNotUseSemicolons", "FileScopedDeclarationPrivacy", "FullyIndirectEnum", "GroupNumericLiterals",
  "NoAccessLevelOnExtensionDeclaration", "NoCasesWithOnlyFallthrough",
  "NoEmptyTrailingClosureParentheses", "NoLabelsInCasePatterns", "NoParensAroundConditions",
  "NoVoidReturnOnFunctionSignature", "OneCasePerLine", "OneVariableDeclarationPerLine",
  "OrderedImports", "ReturnVoidInsteadOfEmptyTuple", "UseEarlyExits", "UseShorthandTypeNames",
  "UseSingleLinePropertyGetter", "UseTripleSlashForDocumentationComments",
  "UseWhereClausesInForLoops",
]

public struct AppState: Equatable {
  public var configuration: Configuration
  public var selectedTab: Tab = .formatting
  public var didRunBefore: Bool
  public var useConfigurationAutodiscovery: Bool

  public init(configuration: Configuration, didRunBefore: Bool, useConfigurationAutodiscovery: Bool)
  {
    self.didRunBefore = getDidRunBefore()
    self.configuration = configuration
    self.useConfigurationAutodiscovery = useConfigurationAutodiscovery

    self.configuration.rules = Configuration().rules.filter { formatterRulesKeys.contains($0.key) }

    for rule in self.configuration.rules {
      if self.configuration.rules[rule.key] != nil {
        self.configuration.rules[rule.key] = rule.value
      }
    }
  }
}

public enum AppAction {
  case setDidRunBefore(value: Bool)
  case settingsView(SettingsViewAction)
}

extension AppState {
  var settingsView: SettingsViewState {
    get {
      SettingsViewState(
        configuration: self.configuration,
        selectedTab: self.selectedTab,
        useConfigurationAutodiscovery: self.useConfigurationAutodiscovery
      )
    }
    set {
      self.configuration = newValue.configuration
      self.selectedTab = newValue.selectedTab
      self.useConfigurationAutodiscovery = newValue.useConfigurationAutodiscovery
    }
  }
}

let appReducer = Reducer<AppState, AppAction, Void>
  .combine(
    Reducer { state, action, _ in
      switch action {
      case .setDidRunBefore(let value):
        state.didRunBefore = value
        return .fireAndForget { setDidRunBefore() }
      case .settingsView(_): return .none
      }
    },
    settingsViewReducer.pullback(
      state: \AppState.settingsView,
      action: /AppAction.settingsView,
      environment: {}
    )
  )

public struct ContentView: View {
  let store: Store<AppState, AppAction>

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      SettingsView(
        store: self.store.scope(state: { $0.settingsView }, action: { .settingsView($0) })
      )
    }
    .navigationTitle("Swift Formatter")
  }
}

extension Reducer where State == AppState, Action == AppAction, Environment == Void {
  func saveMiddleware() -> Reducer {
    .init { state, action, environment in
      switch action {
      case .settingsView:
        let effects = self(&state, action, environment)
        let newState = state
        return .concatenate(
          .fireAndForget {
            dumpConfiguration(
              configuration: newState.configuration,
              outputFileURL: AppConstants.configFileURL,
              createIntermediateDirectories: true
            )
          },
          effects
        )
      default: return self(&state, action, environment)
      }
    }
  }
}

func getDidRunBefore() -> Bool {
  UserDefaults(suiteName: "group.com.kuglee.SwiftFormatter")!
    .bool(forKey: AppConstants.didRunBeforeKey)
}

func setDidRunBefore() {
  UserDefaults(suiteName: "group.com.kuglee.SwiftFormatter")!
    .set(true, forKey: AppConstants.didRunBeforeKey)
}

func getUseConfigurationAutodiscovery() -> Bool {
  UserDefaults(suiteName: "group.com.kuglee.SwiftFormatter")!
    .bool(forKey: AppConstants.useConfigurationAutodiscovery)
}
