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
  public var shouldTrimTrailingWhitespace: Bool

  public init(configuration: Configuration, didRunBefore: Bool, shouldTrimTrailingWhitespace: Bool)
  {
    self.didRunBefore = didRunBefore
    self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
    self.configuration = configuration

    self.configuration.rules = Configuration().rules.filter { formatterRulesKeys.contains($0.key) }

    for rule in self.configuration.rules {
      if self.configuration.rules[rule.key] != nil {
        self.configuration.rules[rule.key] = rule.value
      }
    }
  }
}

public enum AppAction {
  case setDidRunBefore
  case settingsView(SettingsViewAction)
}

extension AppState {
  var settingsView: SettingsViewState {
    get {
      SettingsViewState(
        configuration: self.configuration,
        shouldTrimTrailingWhitespace: self.shouldTrimTrailingWhitespace,
        selectedTab: self.selectedTab
      )
    }
    set {
      self.configuration = newValue.configuration
      self.selectedTab = newValue.selectedTab
      self.shouldTrimTrailingWhitespace = newValue.shouldTrimTrailingWhitespace
    }
  }
}

public let appReducer = Reducer<AppState, AppAction, Void>
  .combine(
    Reducer { state, action, _ in
      switch action {
      case .setDidRunBefore:
        state.didRunBefore = true
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

func appViewBody(store: Store<AppState, AppAction>, onAppearFirstRun: (() -> Void)? = nil)
  -> some View
{
  WithViewStore(store) { viewStore in
    SettingsView(store: store.scope(state: { $0.settingsView }, action: { .settingsView($0) }))
      .onAppear {
        if !viewStore.didRunBefore {
          viewStore.send(.setDidRunBefore)
          if let onAppearFirstRun = onAppearFirstRun { onAppearFirstRun() }
        }
      }
  }
}

@available(macOS 13.0, *) public struct AppViewMacOS13: View {
  let store: Store<AppState, AppAction>
  @Environment(\.openWindow) private var openWindow

  public init(store: Store<AppState, AppAction>) { self.store = store }

  public var body: some View {
    appViewBody(store: self.store) {
      Task {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
        openWindow(id: "welcome")
      }
    }
  }
}

public struct AppViewMacOS12: View {
  let store: Store<AppState, AppAction>

  public init(store: Store<AppState, AppAction>) { self.store = store }

  public var body: some View { appViewBody(store: self.store) }
}

func setDidRunBefore() {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .set(true, forKey: AppConstants.didRunBeforeKey)
}
