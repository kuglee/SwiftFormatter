import About
import ComposableArchitecture
import Rules
import Settings
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI

public struct AppState {
  public var configuration: Configuration
  public var selectedTab: Int
}

enum AppAction {
  case settingsView(SettingsViewAction)

  var settingsView: SettingsViewAction? {
    get {
      guard case let .settingsView(value) = self else { return nil }
      return value
    }
    set {
      guard case .settingsView = self, let newValue = newValue else { return }
      self = .settingsView(newValue)
    }
  }

  case rulesView(RulesViewAction)

  var rulesView: RulesViewAction? {
    get {
      guard case let .rulesView(value) = self else { return nil }
      return value
    }
    set {
      guard case .rulesView = self, let newValue = newValue else { return }
      self = .rulesView(newValue)
    }
  }

  case tabView(TabViewAction)

  var tabView: TabViewAction? {
    get {
      guard case let .tabView(value) = self else { return nil }
      return value
    }
    set {
      guard case .tabView = self, let newValue = newValue else { return }
      self = .tabView(newValue)
    }
  }
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
          .lineBreakAroundMultilineExpressionChainComponents
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

enum TabViewAction: Equatable { case tabSelected(Int) }

struct TabViewState { var selectedTab: Int }

func tabViewReducer(state: inout TabViewState, action: TabViewAction)
  -> [Effect<TabViewAction>]
{
  switch action {
  case .tabSelected(let selectedTab):
    state.selectedTab = selectedTab
    return []
  }
}

let appReducer = combine(
  pullback(
    settingsViewReducer,
    value: \AppState.settingsView,
    action: \AppAction.settingsView
  ),
  pullback(
    rulesViewReducer,
    value: \AppState.rulesView,
    action: \AppAction.rulesView
  ),
  pullback(tabViewReducer, value: \AppState.tabView, action: \AppAction.tabView)
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
      .padding().tabItem { Text("Formatter") }.tag(0)
      RulesView(
        store: self.store.view(
          value: { $0.rulesView },
          action: { .rulesView($0) }
        )
      )
      .padding().tabItem { Text("Linter") }.tag(1)
      AboutView().padding().tabItem { Text("About") }.tag(2)
    }
    .modifier(PrimaryTabViewStyle())
  }
}
