import About
import ComposableArchitecture
import Rules
import Settings
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import os.log

public struct AppState { public var configuration: Configuration }

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
        blankLineBetweenMembers: self.configuration.blankLineBetweenMembers,
        lineBreakBeforeControlFlowKeywords: self.configuration
          .lineBreakBeforeControlFlowKeywords,
        lineBreakBeforeEachArgument: self.configuration
          .lineBreakBeforeEachArgument,
        lineBreakBeforeEachGenericRequirement: self.configuration
          .lineBreakBeforeEachGenericRequirement,
        prioritizeKeepingFunctionOutputTogether: self.configuration
          .prioritizeKeepingFunctionOutputTogether,
        indentConditionalCompilationBlocks: self.configuration
          .indentConditionalCompilationBlocks
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
      self.configuration.blankLineBetweenMembers =
        newValue.blankLineBetweenMembers
    }
  }
  
  var rulesView: RulesViewState {
    get { RulesViewState(rules: self.configuration.rules) }
    set { self.configuration.rules = newValue.rules }
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
  )
)

struct ContentView: View {
  @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
    TabView {
      SettingsView(
        store: self.store.view(
          value: { $0.settingsView },
          action: { .settingsView($0) }
        )
      ).padding().tabItem { Text("Formatting") }.tag(0)
      RulesView(
        store: self.store.view(
          value: { $0.rulesView },
          action: { .rulesView($0) }
        )
      ).padding().tabItem { Text("Rules") }.tag(1)
      AboutView().padding().tabItem { Text("About") }.tag(2)
    }.modifier(PrimaryTabViewStyle())
  }
}
