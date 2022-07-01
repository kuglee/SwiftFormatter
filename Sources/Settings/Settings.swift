import AppConstants
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

public struct SettingsViewState: Equatable {
  public var configuration: Configuration
  public var selectedTab: Tab
  public var useConfigurationAutodiscovery: Bool

  public init(
    configuration: Configuration,
    selectedTab: Tab = .formatting,
    useConfigurationAutodiscovery: Bool
  ) {
    self.configuration = configuration
    self.useConfigurationAutodiscovery = useConfigurationAutodiscovery
    self.selectedTab = selectedTab
  }
}

public enum SettingsViewAction: Equatable {
  case useConfigurationAutodiscoveryFilledOut(Bool)
  case tabSelected(Tab)
  case formatterSettingsView(FormatterSettingsViewAction)
  case formatterRulesView(FormatterRulesViewAction)
}

extension SettingsViewState {
  var formatterSettingsView: FormatterSettingsViewState {
    get {
      FormatterSettingsViewState(
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

  var formatterRulesView: FormatterRulesViewState {
    get { FormatterRulesViewState(rules: self.configuration.rules) }
    set { self.configuration.rules = newValue.rules }
  }
}

public let settingsViewReducer = Reducer<SettingsViewState, SettingsViewAction, Void>
  .combine(
    Reducer { state, action, _ in
      switch action {
      case .useConfigurationAutodiscoveryFilledOut(let value):
        state.selectedTab = .formatting
        state.useConfigurationAutodiscovery = value
        return .fireAndForget { setUseConfigurationAutodiscovery(newValue: value) }
      case .tabSelected(let selectedTab):
        state.selectedTab = selectedTab
        return .none
      case .formatterSettingsView(_): return .none
      case .formatterRulesView(_): return .none
      }
    },
    formatterSettingsViewReducer.pullback(
      state: \SettingsViewState.formatterSettingsView,
      action: /SettingsViewAction.formatterSettingsView,
      environment: {}
    ),
    formatterRulesViewReducer.pullback(
      state: \SettingsViewState.formatterRulesView,
      action: /SettingsViewAction.formatterRulesView,
      environment: {}
    )
  )

public struct SettingsView: View {
  let store: Store<SettingsViewState, SettingsViewAction>

  public init(store: Store<SettingsViewState, SettingsViewAction>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        VStack(alignment: .leadingAlignmentGuide, spacing: .grid(2)) {
          Toggle(
            isOn: Binding(
              get: { viewStore.useConfigurationAutodiscovery },
              set: { viewStore.send(.useConfigurationAutodiscoveryFilledOut($0)) }
            )
          ) { Text("Use configuration autodiscovery").modifier(LeadingAlignmentStyle()) }
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
          .help(
            "For any source file being checked or formatted, swift-format looks for a JSON-formatted file named .swift-format in the same directory. If one is found, then that file is loaded to determine the tool's configuration. If the file is not found, then it looks in the parent directory, and so on."
          )
          Text("Use .swift-format configuration files based on source file location.")
            .modifier(SecondaryTextStyle())
        }
        .padding(.top, .grid(8))
        TabView(
          selection: Binding(
            get: { viewStore.selectedTab },
            set: { viewStore.send(.tabSelected($0)) }
          )
        ) {
          FormatterSettingsView(
            store: self.store.scope(
              state: { $0.formatterSettingsView },
              action: { .formatterSettingsView($0) }
            )
          )
          .tabItem { Text("Formatting") }.tag(Tab.formatting).modifier(PrimaryTabItemStyle())
          FormatterRulesView(
            store: self.store.scope(
              state: { $0.formatterRulesView },
              action: { .formatterRulesView($0) }
            )
          )
          .modifier(PrimaryTabItemStyle()).tabItem { Text("Rules") }.tag(Tab.rules)
        }
        .modifier(PrimaryTabViewStyle()).disabled(viewStore.useConfigurationAutodiscovery)
      }
      .frame(width: 650, height: 620)
    }
  }
}

func setUseConfigurationAutodiscovery(newValue: Bool) {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .set(newValue, forKey: AppConstants.useConfigurationAutodiscoveryKey)
}
