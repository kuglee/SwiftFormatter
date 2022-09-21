import ComposableArchitecture
import FormatterRules
import FormatterSettings
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI

public enum Tab {
  case formatting
  case rules
}

public struct SettingsFeature: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    public var configuration: Configuration
    public var shouldTrimTrailingWhitespace: Bool
    public var selectedTab: Tab

    public init(
      configuration: Configuration,
      shouldTrimTrailingWhitespace: Bool,
      selectedTab: Tab = .formatting
    ) {
      self.configuration = configuration
      self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
      self.selectedTab = selectedTab
    }
  }

  public enum Action: Equatable {
    case tabSelected(Tab)
    case formatterSettings(action: FormatterSettings.Action)
    case formatterRules(action: FormatterRules.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .tabSelected(let selectedTab):
        state.selectedTab = selectedTab
        return .none
      case .formatterSettings(_): return .none
      case .formatterRules(_): return .none
      }
    }
    Scope(state: \.formatterSettings, action: /Action.formatterSettings(action:)) {
      FormatterSettings()
    }
    Scope(state: \.formatterRules, action: /Action.formatterRules(action:)) { FormatterRules() }
  }
}

extension SettingsFeature.State {
  var formatterSettings: FormatterSettings.State {
    get {
      FormatterSettings.State(
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
        fileScopedDeclarationPrivacy: self.configuration.fileScopedDeclarationPrivacy,
        shouldTrimTrailingWhitespace: self.shouldTrimTrailingWhitespace
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
      self.shouldTrimTrailingWhitespace = newValue.shouldTrimTrailingWhitespace
    }
  }

  var formatterRules: FormatterRules.State {
    get { FormatterRules.State(rules: self.configuration.rules) }
    set { self.configuration.rules = newValue.rules }
  }
}

public struct SettingsView: View {
  let store: StoreOf<SettingsFeature>

  public init(store: StoreOf<SettingsFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      TabView(
        selection: Binding(
          get: { viewStore.selectedTab },
          set: { viewStore.send(.tabSelected($0)) }
        )
      ) {
        Group {
          FormatterSettingsView(
            store: self.store.scope(
              state: \.formatterSettings,
              action: SettingsFeature.Action.formatterSettings
            )
          )
          .tabItem { Text("Formatting") }.tag(Tab.formatting)
          FormatterRulesView(
            store: self.store.scope(
              state: \.formatterRules,
              action: SettingsFeature.Action.formatterRules
            )
          )
          .tabItem { Text("Rules") }.tag(Tab.rules)
        }
        .padding(.grid(3))
      }
      .frame(width: 600, height: 532).padding(.grid(5))
    }
  }
}
