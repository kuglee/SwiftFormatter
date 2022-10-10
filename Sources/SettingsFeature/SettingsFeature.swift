import ComposableArchitecture
import ConfigurationWrapper
import FormatterRules
import FormatterSettings
import StyleGuide
import SwiftUI

public enum Tab {
  case formatting
  case rules
}

public struct SettingsFeature: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    public var configuration: ConfigurationWrapper
    public var shouldTrimTrailingWhitespace: Bool
    public var selectedTab: Tab

    public init(
      configuration: ConfigurationWrapper,
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

public struct SettingsFeatureView: View {
  let store: StoreOf<SettingsFeature>

  public init(store: StoreOf<SettingsFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store, observe: \.selectedTab) { viewStore in
      TabView(selection: viewStore.binding(send: SettingsFeature.Action.tabSelected)) {
        Group {
          IfView(viewStore.state == .formatting) {
            FormatterSettingsView(
              store: self.store.scope(
                state: \.formatterSettings,
                action: SettingsFeature.Action.formatterSettings
              )
            )
          }
          .tabItem { Text("Formatting") }.tag(Tab.formatting)

          IfView(viewStore.state == .rules) {
            FormatterRulesView(
              store: self.store.scope(
                state: \.formatterRules,
                action: SettingsFeature.Action.formatterRules
              )
            )
          }
          .tabItem { Text("Rules") }.tag(Tab.rules)
        }
        .padding(.grid(3))
      }
      .frame(width: 600, height: 532).padding(.grid(5))
    }
  }
}

// workaround for SwiftUI rerendering non-selected TabViews bug:
// https://github.com/pointfreeco/swift-composable-architecture/discussions/391
// can't be an extension method on View because it can't be type checked in a reasonable time
struct IfView<Content>: View where Content: View {
  let condition: Bool
  let content: () -> Content

  init(_ condition: Bool, @ViewBuilder content: @escaping () -> Content) {
    self.condition = condition
    self.content = content
  }

  var body: some View {
    Group {
      if self.condition {
        self.content()
      } else {
        // can't use an EmptyView here because with that the tabItem won't be shown
        Text("")
      }
    }
  }
}
