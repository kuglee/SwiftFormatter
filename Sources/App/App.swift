import AppConstants
import ComposableArchitecture
import ConfigurationManager
import Settings
import StyleGuide
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

public struct AppState: Equatable {
  public var configuration: Configuration
  public var selectedTab: Tab = .formatting
  public var didRunBefore: Bool
  public var useConfigurationAutodiscovery: Bool

  public init(configuration: Configuration, didRunBefore: Bool, useConfigurationAutodiscovery: Bool)
  {
    self.didRunBefore = didRunBefore
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

public let appReducer = Reducer<AppState, AppAction, Void>
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

public struct AppView: View {
  let store: Store<AppState, AppAction>

  public init(store: Store<AppState, AppAction>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      SettingsView(
        store: self.store.scope(state: { $0.settingsView }, action: { .settingsView($0) })
      )
    }
  }
}

func setDidRunBefore() {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .set(true, forKey: AppConstants.didRunBeforeKey)
}
