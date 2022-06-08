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
  "DoNotUseSemicolons",
  "FileScopedDeclarationPrivacy",
  "FullyIndirectEnum",
  "GroupNumericLiterals",
  "NoAccessLevelOnExtensionDeclaration",
  "NoCasesWithOnlyFallthrough",
  "NoEmptyTrailingClosureParentheses",
  "NoLabelsInCasePatterns",
  "NoParensAroundConditions",
  "NoVoidReturnOnFunctionSignature",
  "OneCasePerLine",
  "OneVariableDeclarationPerLine",
  "OrderedImports",
  "ReturnVoidInsteadOfEmptyTuple",
  "UseEarlyExits",
  "UseShorthandTypeNames",
  "UseSingleLinePropertyGetter",
  "UseTripleSlashForDocumentationComments",
  "UseWhereClausesInForLoops",
]

public struct AppState {
  public var configuration: Configuration
  public var selectedTab: Int

  public init(configuration: Configuration, selectedTab: Int) {
    self.selectedTab = selectedTab
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
        respectsExistingLineBreaks: self.configuration
          .respectsExistingLineBreaks,
        lineBreakBeforeControlFlowKeywords: self.configuration
          .lineBreakBeforeControlFlowKeywords,
        lineBreakBeforeEachArgument: self.configuration
          .lineBreakBeforeEachArgument,
        lineBreakBeforeEachGenericRequirement: self.configuration
          .lineBreakBeforeEachGenericRequirement,
        prioritizeKeepingFunctionOutputTogether: self.configuration
          .prioritizeKeepingFunctionOutputTogether,
        indentConditionalCompilationBlocks: self.configuration
          .indentConditionalCompilationBlocks,
        lineBreakAroundMultilineExpressionChainComponents: self.configuration
          .lineBreakAroundMultilineExpressionChainComponents,
        fileScopedDeclarationPrivacy: self.configuration
          .fileScopedDeclarationPrivacy
      )
    }
    set {
      self.configuration.maximumBlankLines = newValue.maximumBlankLines
      self.configuration.lineLength = newValue.lineLength
      self.configuration.tabWidth = newValue.tabWidth
      self.configuration.indentation = newValue.indentation
      self.configuration.respectsExistingLineBreaks =
        newValue.respectsExistingLineBreaks
      self.configuration.lineBreakBeforeControlFlowKeywords =
        newValue.lineBreakBeforeControlFlowKeywords
      self.configuration.lineBreakBeforeEachArgument =
        newValue.lineBreakBeforeEachArgument
      self.configuration.lineBreakBeforeEachGenericRequirement =
        newValue.lineBreakBeforeEachGenericRequirement
      self.configuration.prioritizeKeepingFunctionOutputTogether =
        newValue.prioritizeKeepingFunctionOutputTogether
      self.configuration.indentConditionalCompilationBlocks =
        newValue.indentConditionalCompilationBlocks
      self.configuration.lineBreakAroundMultilineExpressionChainComponents =
        newValue.lineBreakAroundMultilineExpressionChainComponents
      self.configuration.fileScopedDeclarationPrivacy =
        newValue.fileScopedDeclarationPrivacy
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

func tabViewReducer(state: inout TabViewState, action: TabViewAction)
  -> [Effect<TabViewAction>]
{
  switch action {
  case .tabSelected(let selectedTab):
    state.selectedTab = selectedTab
    return []
  }
}

public func saveMiddleware(_ reducer: @escaping Reducer<AppState, AppAction>)
  -> Reducer<AppState, AppAction>
{
  return { state, action in
    switch action {
    case .settingsView, .rulesView:
      let effects = reducer(&state, action)
      let newState = state
      return [
        .fireAndForget {
          dumpConfiguration(
            configuration: newState.configuration,
            outputFileURL: AppConstants.configFileURL,
            createIntermediateDirectories: true
          )
        }
      ] + effects
    default: return reducer(&state, action)
    }
  }
}

let appReducer = combine(
  pullback(
    settingsViewReducer,
    value: \AppState.settingsView,
    action: /AppAction.settingsView
  ),
  pullback(
    rulesViewReducer,
    value: \AppState.rulesView,
    action: /AppAction.rulesView
  ),
  pullback(tabViewReducer, value: \AppState.tabView, action: /AppAction.tabView)
)

struct ContentView: View {
  @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
    TabView(
      selection: Binding(
        get: { self.store.value.selectedTab },
        set: { self.store.send(.tabView(.tabSelected($0))) }
      )
    ) {
      SettingsView(
        store: self.store.view(
          value: { $0.settingsView },
          action: { .settingsView($0) }
        )
      )
      .modifier(PrimaryTabItemStyle()).tabItem { Text("Formatting") }.tag(0)
      RulesView(
        store: self.store.view(
          value: { $0.rulesView },
          action: { .rulesView($0) }
        )
      )
      .modifier(PrimaryTabItemStyle()).tabItem { Text("Rules") }.tag(1)
      AboutView().modifier(PrimaryTabItemStyle()).tabItem { Text("About") }
        .tag(2)
    }
    .modifier(PrimaryTabViewStyle())
  }
}
