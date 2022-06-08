import About
import CasePaths
import ComposableArchitecture
import ConfigurationManager
import Rules
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
  public var selectedTab: Int
  public var didRunBefore: Bool

  public init(configuration: Configuration, didRunBefore: Bool) {
    self.didRunBefore = getDidRunBefore()
    self.selectedTab = !self.didRunBefore ? 2 : 0
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
  case setDidRunBefore(value: Bool)
  case settingsView(SettingsViewAction)
  case rulesView(RulesViewAction)
  case tabView(TabViewAction)
}

extension AppState {
  var settingsView: SettingsViewState {
    get {
      SettingsViewState(
        maximumBlankLines: self.configuration.maximumBlankLines,
        lineLength: self.configuration.lineLength,
        tabWidth: self.configuration.tabWidth,
        indentation: self.configuration.indentation,
        respectsExistingLineBreaks: self.configuration.respectsExistingLineBreaks,
        lineBreakBeforeControlFlowKeywords: self.configuration.lineBreakBeforeControlFlowKeywords,
        lineBreakBeforeEachArgument: self.configuration.lineBreakBeforeEachArgument,
        lineBreakBeforeEachGenericRequirement: self.configuration
          .lineBreakBeforeEachGenericRequirement,
        prioritizeKeepingFunctionOutputTogether: self.configuration
          .prioritizeKeepingFunctionOutputTogether,
        indentConditionalCompilationBlocks: self.configuration.indentConditionalCompilationBlocks,
        indentSwitchCaseLabels: self.configuration.indentSwitchCaseLabels,
        lineBreakAroundMultilineExpressionChainComponents: self.configuration
          .lineBreakAroundMultilineExpressionChainComponents,
        fileScopedDeclarationPrivacy: self.configuration.fileScopedDeclarationPrivacy
      )
    }
    set {
      self.configuration.maximumBlankLines = newValue.maximumBlankLines
      self.configuration.lineLength = newValue.lineLength
      self.configuration.tabWidth = newValue.tabWidth
      self.configuration.indentation = newValue.indentation
      self.configuration.respectsExistingLineBreaks = newValue.respectsExistingLineBreaks
      self.configuration.lineBreakBeforeControlFlowKeywords =
        newValue.lineBreakBeforeControlFlowKeywords
      self.configuration.lineBreakBeforeEachArgument = newValue.lineBreakBeforeEachArgument
      self.configuration.lineBreakBeforeEachGenericRequirement =
        newValue.lineBreakBeforeEachGenericRequirement
      self.configuration.prioritizeKeepingFunctionOutputTogether =
        newValue.prioritizeKeepingFunctionOutputTogether
      self.configuration.indentConditionalCompilationBlocks =
        newValue.indentConditionalCompilationBlocks
      self.configuration.indentSwitchCaseLabels = newValue.indentSwitchCaseLabels
      self.configuration.lineBreakAroundMultilineExpressionChainComponents =
        newValue.lineBreakAroundMultilineExpressionChainComponents
      self.configuration.fileScopedDeclarationPrivacy = newValue.fileScopedDeclarationPrivacy
    }
  }

  var rulesView: RulesViewState {
    get { RulesViewState(rules: self.configuration.rules) }
    set { self.configuration.rules = newValue.rules }
  }

  var tabView: TabViewState {
    get { TabViewState(selectedTab: self.selectedTab) }
    set { self.selectedTab = newValue.selectedTab }
  }
}

public enum TabViewAction: Equatable { case tabSelected(Int) }

public struct TabViewState { var selectedTab: Int }

public let tabViewReducer = Reducer<TabViewState, TabViewAction, Void> { state, action, _ in
  switch action {
  case .tabSelected(let selectedTab):
    state.selectedTab = selectedTab
    return .none
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
      case .rulesView(_): return .none
      case .tabView(_): return .none
      }
    },
    settingsViewReducer.pullback(
      state: \AppState.settingsView,
      action: /AppAction.settingsView,
      environment: {}
    ),
    rulesViewReducer.pullback(
      state: \AppState.rulesView,
      action: /AppAction.rulesView,
      environment: {}
    ),
    tabViewReducer.pullback(state: \AppState.tabView, action: /AppAction.tabView, environment: {})
  )

public struct ContentView: View {
  let store: Store<AppState, AppAction>

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      TabView(
        selection: Binding(
          get: { viewStore.selectedTab },
          set: { viewStore.send(.tabView(.tabSelected($0))) }
        )
      ) {
        SettingsView(
          store: self.store.scope(state: { $0.settingsView }, action: { .settingsView($0) })
        )
        .modifier(PrimaryTabItemStyle()).tabItem { Text("Formatting") }.tag(0)
        RulesView(store: self.store.scope(state: { $0.rulesView }, action: { .rulesView($0) }))
          .modifier(PrimaryTabItemStyle()).tabItem { Text("Rules") }.tag(1)
        AboutView().modifier(PrimaryTabItemStyle()).tabItem { Text("About") }.tag(2)
      }
      .modifier(PrimaryTabViewStyle()).navigationTitle("Swift Formatter")
      .onAppear { if !viewStore.didRunBefore { viewStore.send(.setDidRunBefore(value: true)) } }
    }
  }
}

extension Reducer where State == AppState, Action == AppAction, Environment == Void {
  func saveMiddleware() -> Reducer {
    .init { state, action, environment in
      switch action {
      case .settingsView, .rulesView:
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

func getDidRunBefore() -> Bool { UserDefaults.standard.bool(forKey: AppConstants.didRunBeforeKey) }

func setDidRunBefore() { UserDefaults.standard.set(true, forKey: AppConstants.didRunBeforeKey) }
