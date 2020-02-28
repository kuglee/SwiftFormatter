import CasePaths
import ComposableArchitecture
import FileScopedDeclarationPrivacy
import Indentation
import LineBreaks
import LineLength
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import TabWidth
import Utility

public enum SettingsViewAction: Equatable {
  case indentationView(IndentationViewAction)
  case tabWidthView(TabWidthViewAction)
  case lineLengthView(LineLengthViewAction)
  case lineBreaksView(LineBreaksViewAction)
  case fileScopedDeclarationPrivacyView(FileScopedDeclarationPrivacyViewAction)
}

public struct SettingsViewState {
  public var maximumBlankLines: Int
  public var lineLength: Int
  public var tabWidth: Int
  public var indentation: Indent
  public var respectsExistingLineBreaks: Bool
  public var lineBreakBeforeControlFlowKeywords: Bool
  public var lineBreakBeforeEachArgument: Bool
  public var lineBreakBeforeEachGenericRequirement: Bool
  public var prioritizeKeepingFunctionOutputTogether: Bool
  public var indentConditionalCompilationBlocks: Bool
  public var lineBreakAroundMultilineExpressionChainComponents: Bool
  public var fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration

  public init(
    maximumBlankLines: Int,
    lineLength: Int,
    tabWidth: Int,
    indentation: Indent,
    respectsExistingLineBreaks: Bool,
    lineBreakBeforeControlFlowKeywords: Bool,
    lineBreakBeforeEachArgument: Bool,
    lineBreakBeforeEachGenericRequirement: Bool,
    prioritizeKeepingFunctionOutputTogether: Bool,
    indentConditionalCompilationBlocks: Bool,
    lineBreakAroundMultilineExpressionChainComponents: Bool,
    fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration
  ) {
    self.maximumBlankLines = maximumBlankLines
    self.lineLength = lineLength
    self.tabWidth = tabWidth
    self.indentation = indentation
    self.respectsExistingLineBreaks = respectsExistingLineBreaks
    self.lineBreakBeforeControlFlowKeywords = lineBreakBeforeControlFlowKeywords
    self.lineBreakBeforeEachArgument = lineBreakBeforeEachArgument
    self.lineBreakBeforeEachGenericRequirement =
      lineBreakBeforeEachGenericRequirement
    self.prioritizeKeepingFunctionOutputTogether =
      prioritizeKeepingFunctionOutputTogether
    self.indentConditionalCompilationBlocks = indentConditionalCompilationBlocks
    self.lineBreakAroundMultilineExpressionChainComponents =
      lineBreakAroundMultilineExpressionChainComponents
    self.fileScopedDeclarationPrivacy = fileScopedDeclarationPrivacy
  }
}

extension SettingsViewState {
  var indentationView: IndentationViewState {
    get {
      IndentationViewState(
        indentation: self.indentation,
        indentConditionalCompilationBlocks: self
          .indentConditionalCompilationBlocks
      )
    }
    set {
      self.indentation = newValue.indentation
      self.indentConditionalCompilationBlocks =
        newValue.indentConditionalCompilationBlocks
    }
  }

  var tabWidthView: TabWidthViewState {
    get { TabWidthViewState(tabWidth: self.tabWidth) }
    set { self.tabWidth = newValue.tabWidth }
  }

  var lineLengthView: LineLengthViewState {
    get { LineLengthViewState(lineLength: self.lineLength) }
    set { self.lineLength = newValue.lineLength }
  }

  var lineBreaksView: LineBreaksViewState {
    get {
      LineBreaksViewState(
        maximumBlankLines: self.maximumBlankLines,
        respectsExistingLineBreaks: self.respectsExistingLineBreaks,
        lineBreakBeforeControlFlowKeywords: self
          .lineBreakBeforeControlFlowKeywords,
        lineBreakBeforeEachArgument: self.lineBreakBeforeEachArgument,
        lineBreakBeforeEachGenericRequirement: self
          .lineBreakBeforeEachGenericRequirement,
        prioritizeKeepingFunctionOutputTogether: self
          .prioritizeKeepingFunctionOutputTogether,
        lineBreakAroundMultilineExpressionChainComponents: self
          .lineBreakAroundMultilineExpressionChainComponents
      )
    }
    set {
      self.maximumBlankLines = newValue.maximumBlankLines
      self.respectsExistingLineBreaks = newValue.respectsExistingLineBreaks
      self.lineBreakBeforeControlFlowKeywords =
        newValue.lineBreakBeforeControlFlowKeywords
      self.lineBreakBeforeEachArgument = newValue.lineBreakBeforeEachArgument
      self.lineBreakBeforeEachGenericRequirement =
        newValue.lineBreakBeforeEachGenericRequirement
      self.prioritizeKeepingFunctionOutputTogether =
        newValue.prioritizeKeepingFunctionOutputTogether
      self.lineBreakAroundMultilineExpressionChainComponents =
        newValue.lineBreakAroundMultilineExpressionChainComponents
    }
  }

  var fileScopedDeclarationPrivacyView: FileScopedDeclarationPrivacyViewState {
    get {
      FileScopedDeclarationPrivacyViewState(
        accessLevel: self.fileScopedDeclarationPrivacy.accessLevel)
    }
    set {
      self.fileScopedDeclarationPrivacy.accessLevel = newValue.accessLevel
    }
  }
}

public let settingsViewReducer = combine(
  pullback(
    indentationViewReducer,
    value: \SettingsViewState.indentationView,
    action: /SettingsViewAction.indentationView
  ),
  pullback(
    tabWidthViewReducer,
    value: \SettingsViewState.tabWidthView,
    action: /SettingsViewAction.tabWidthView
  ),
  pullback(
    lineLengthViewReducer,
    value: \SettingsViewState.lineLengthView,
    action: /SettingsViewAction.lineLengthView
  ),
  pullback(
    lineBreaksViewReducer,
    value: \SettingsViewState.lineBreaksView,
    action: /SettingsViewAction.lineBreaksView
  ),
  pullback(
    fileScopedDeclarationPrivacyViewReducer,
    value: \SettingsViewState.fileScopedDeclarationPrivacyView,
    action: /SettingsViewAction.fileScopedDeclarationPrivacyView
  )
)

public struct SettingsView: View {
  internal enum InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  @ObservedObject var store: Store<SettingsViewState, SettingsViewAction>

  public init(store: Store<SettingsViewState, SettingsViewAction>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .trailingAlignmentGuide, spacing: .grid(3)) {
      IndentationView(
        store: self.store.view(
          value: { $0.indentationView },
          action: { .indentationView($0) }
        )
      )
      TabWidthView(
        store: self.store.view(
          value: { $0.tabWidthView },
          action: { .tabWidthView($0) }
        )
      )
      LineLengthView(
        store: self.store.view(
          value: { $0.lineLengthView },
          action: { .lineLengthView($0) }
        )
      )
      LineBreaksView(
        store: self.store.view(
          value: { $0.lineBreaksView },
          action: { .lineBreaksView($0) }
        )
      )
      FileScopedDeclarationPrivacyViewView(
        store: self.store.view(
          value: { $0.fileScopedDeclarationPrivacyView },
          action: { .fileScopedDeclarationPrivacyView($0) }
        )
      )
    }
    .modifier(PrimaryVStackStyle())
  }
}
