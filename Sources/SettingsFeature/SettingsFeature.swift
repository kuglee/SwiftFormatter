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

public struct SettingsFeature: Reducer {
  public init() {}

  public struct State: Equatable {
    public var configuration: ConfigurationWrapper
    public var shouldTrimTrailingWhitespace: Bool
    public var selectedTab: Tab
    public var noAssignmentInExpressionsState: NoAssignmentInExpressions.State
    public var focusedField: FormatterSettings.State.Field?

    public init(
      configuration: ConfigurationWrapper,
      shouldTrimTrailingWhitespace: Bool,
      selectedTab: Tab = .formatting,
      focusedField: FormatterSettings.State.Field? = nil
    ) {
      @Dependency(\.uuid) var uuid

      self.configuration = configuration
      self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
      self.selectedTab = selectedTab
      self.focusedField = focusedField
      self.noAssignmentInExpressionsState = .init(
        noAssignmentInExpressionsItems: IdentifiedArray(
          uniqueElements: configuration.noAssignmentInExpressions.allowedFunctions.map {
            NoAssignmentInExpressionsList.State.NoAssignmentInExpressionsListItem(
              id: uuid(),
              text: $0
            )
          }
        ),
        noAssignmentInExpressionsListState: nil,
        editingState: nil
      )
    }
  }

  public enum Action: Equatable {
    case tabSelected(Tab)
    case formatterSettings(action: FormatterSettings.Action)
    case formatterRules(action: FormatterRules.Action)
  }

  public var body: some ReducerOf<Self> {
    Scope(state: \.formatterSettings, action: /Action.formatterSettings(action:)) {
      FormatterSettings()
    }
    Scope(state: \.formatterRules, action: /Action.formatterRules(action:)) { FormatterRules() }

    Reduce { state, action in
      switch action {
      case .tabSelected(let selectedTab):
        state.selectedTab = selectedTab
        return .none
      case .formatterSettings(_): return .none
      case .formatterRules(_): return .none
      }
    }
  }
}

extension SettingsFeature.State {
  var formatterSettings: FormatterSettings.State {
    get {
      FormatterSettings.State(
        shouldTrimTrailingWhitespace: self.shouldTrimTrailingWhitespace,
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
        lineBreakAroundMultilineExpressionChainComponents: self.configuration
          .lineBreakAroundMultilineExpressionChainComponents,
        indentSwitchCaseLabels: self.configuration.indentSwitchCaseLabels,
        fileScopedDeclarationPrivacy: self.configuration.fileScopedDeclarationPrivacy,
        spacesAroundRangeFormationOperators: self.configuration.spacesAroundRangeFormationOperators,
        multiElementCollectionTrailingCommas: self.configuration
          .multiElementCollectionTrailingCommas,
        noAssignmentInExpressionsState: self.noAssignmentInExpressionsState,
        focusedField: self.focusedField
      )
    }
    set {
      self.shouldTrimTrailingWhitespace = newValue.shouldTrimTrailingWhitespace
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
      self.configuration.spacesAroundRangeFormationOperators =
        newValue.spacesAroundRangeFormationOperators
      self.noAssignmentInExpressionsState = newValue.noAssignmentInExpressionsState
      self.configuration.noAssignmentInExpressions.allowedFunctions = newValue
        .noAssignmentInExpressionsState.noAssignmentInExpressionsItems.map(\.text)
      self.configuration.multiElementCollectionTrailingCommas =
        newValue.multiElementCollectionTrailingCommas
      self.focusedField = newValue.focusedField
    }
  }

  var formatterRules: FormatterRules.State {
    get {
      FormatterRules.State(
        alwaysUseLiteralForEmptyCollectionInit: self.configuration.rules
          .alwaysUseLiteralForEmptyCollectionInit,
        doNotUseSemicolons: self.configuration.rules.doNotUseSemicolons,
        fileScopedDeclarationPrivacy: self.configuration.rules.fileScopedDeclarationPrivacy,
        fullyIndirectEnum: self.configuration.rules.fullyIndirectEnum,
        groupNumericLiterals: self.configuration.rules.groupNumericLiterals,
        noAccessLevelOnExtensionDeclaration: self.configuration.rules
          .noAccessLevelOnExtensionDeclaration,
        noAssignmentInExpressions: self.configuration.rules.noAssignmentInExpressions,
        noCasesWithOnlyFallthrough: self.configuration.rules.noCasesWithOnlyFallthrough,
        noEmptyTrailingClosureParentheses: self.configuration.rules
          .noEmptyTrailingClosureParentheses,
        noLabelsInCasePatterns: self.configuration.rules.noLabelsInCasePatterns,
        noParensAroundConditions: self.configuration.rules.noParensAroundConditions,
        noVoidReturnOnFunctionSignature: self.configuration.rules.noVoidReturnOnFunctionSignature,
        omitExplicitReturns: self.configuration.rules.omitExplicitReturns,
        oneCasePerLine: self.configuration.rules.oneCasePerLine,
        oneVariableDeclarationPerLine: self.configuration.rules.oneVariableDeclarationPerLine,
        orderedImports: self.configuration.rules.orderedImports,
        returnVoidInsteadOfEmptyTuple: self.configuration.rules.returnVoidInsteadOfEmptyTuple,
        useEarlyExits: self.configuration.rules.useEarlyExits,
        useExplicitNilCheckInConditions: self.configuration.rules.useExplicitNilCheckInConditions,
        useShorthandTypeNames: self.configuration.rules.useShorthandTypeNames,
        useSingleLinePropertyGetter: self.configuration.rules.useSingleLinePropertyGetter,
        useTripleSlashForDocumentationComments: self.configuration.rules
          .useTripleSlashForDocumentationComments,
        useWhereClausesInForLoops: self.configuration.rules.useWhereClausesInForLoops
      )
    }
    set {
      self.configuration.rules.alwaysUseLiteralForEmptyCollectionInit =
        newValue.alwaysUseLiteralForEmptyCollectionInit
      self.configuration.rules.doNotUseSemicolons = newValue.doNotUseSemicolons
      self.configuration.rules.fileScopedDeclarationPrivacy = newValue.fileScopedDeclarationPrivacy
      self.configuration.rules.fullyIndirectEnum = newValue.fullyIndirectEnum
      self.configuration.rules.groupNumericLiterals = newValue.groupNumericLiterals
      self.configuration.rules.noAccessLevelOnExtensionDeclaration =
        newValue.noAccessLevelOnExtensionDeclaration
      self.configuration.rules.noAssignmentInExpressions = newValue.noAssignmentInExpressions
      self.configuration.rules.noCasesWithOnlyFallthrough = newValue.noCasesWithOnlyFallthrough
      self.configuration.rules.noEmptyTrailingClosureParentheses =
        newValue.noEmptyTrailingClosureParentheses
      self.configuration.rules.noLabelsInCasePatterns = newValue.noLabelsInCasePatterns
      self.configuration.rules.noParensAroundConditions = newValue.noParensAroundConditions
      self.configuration.rules.noVoidReturnOnFunctionSignature =
        newValue.noVoidReturnOnFunctionSignature
      self.configuration.rules.omitExplicitReturns = newValue.omitExplicitReturns
      self.configuration.rules.oneCasePerLine = newValue.oneCasePerLine
      self.configuration.rules.oneVariableDeclarationPerLine =
        newValue.oneVariableDeclarationPerLine
      self.configuration.rules.orderedImports = newValue.orderedImports
      self.configuration.rules.returnVoidInsteadOfEmptyTuple =
        newValue.returnVoidInsteadOfEmptyTuple
      self.configuration.rules.useEarlyExits = newValue.useEarlyExits
      self.configuration.rules.useExplicitNilCheckInConditions =
        newValue.useExplicitNilCheckInConditions
      self.configuration.rules.useShorthandTypeNames = newValue.useShorthandTypeNames
      self.configuration.rules.useSingleLinePropertyGetter = newValue.useSingleLinePropertyGetter
      self.configuration.rules.useTripleSlashForDocumentationComments =
        newValue.useTripleSlashForDocumentationComments
      self.configuration.rules.useWhereClausesInForLoops = newValue.useWhereClausesInForLoops
    }
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
      .frame(width: 600, height: 600).padding(.grid(5))
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
