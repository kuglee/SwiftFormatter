import CasePaths
import ComposableArchitecture
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import Utility

public enum SettingsViewAction: Equatable {
  case indentationView(IndentationViewAction)
  case tabWidthView(TabWidthViewAction)
  case lineLengthView(LineLengthViewAction)
  case lineBreaksView(LineBreaksViewAction)
  case fileScopedDeclarationPrivacyView(FileScopedDeclarationPrivacyViewAction)
}

public struct SettingsViewState: Equatable {
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
  public var indentSwitchCaseLabels: Bool
  public var lineBreakAroundMultilineExpressionChainComponents: Bool
  public var fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration

  public init(
    maximumBlankLines: Int, lineLength: Int, tabWidth: Int, indentation: Indent,
    respectsExistingLineBreaks: Bool, lineBreakBeforeControlFlowKeywords: Bool,
    lineBreakBeforeEachArgument: Bool, lineBreakBeforeEachGenericRequirement: Bool,
    prioritizeKeepingFunctionOutputTogether: Bool, indentConditionalCompilationBlocks: Bool,
    indentSwitchCaseLabels: Bool, lineBreakAroundMultilineExpressionChainComponents: Bool,
    fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration
  ) {
    self.maximumBlankLines = maximumBlankLines
    self.lineLength = lineLength
    self.tabWidth = tabWidth
    self.indentation = indentation
    self.respectsExistingLineBreaks = respectsExistingLineBreaks
    self.lineBreakBeforeControlFlowKeywords = lineBreakBeforeControlFlowKeywords
    self.lineBreakBeforeEachArgument = lineBreakBeforeEachArgument
    self.lineBreakBeforeEachGenericRequirement = lineBreakBeforeEachGenericRequirement
    self.prioritizeKeepingFunctionOutputTogether = prioritizeKeepingFunctionOutputTogether
    self.indentConditionalCompilationBlocks = indentConditionalCompilationBlocks
    self.indentSwitchCaseLabels = indentSwitchCaseLabels
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
        indentConditionalCompilationBlocks: self.indentConditionalCompilationBlocks,
        indentSwitchCaseLabels: self.indentSwitchCaseLabels)
    }
    set {
      self.indentation = newValue.indentation
      self.indentConditionalCompilationBlocks = newValue.indentConditionalCompilationBlocks
      self.indentSwitchCaseLabels = newValue.indentSwitchCaseLabels
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
        lineBreakBeforeControlFlowKeywords: self.lineBreakBeforeControlFlowKeywords,
        lineBreakBeforeEachArgument: self.lineBreakBeforeEachArgument,
        lineBreakBeforeEachGenericRequirement: self.lineBreakBeforeEachGenericRequirement,
        prioritizeKeepingFunctionOutputTogether: self.prioritizeKeepingFunctionOutputTogether,
        lineBreakAroundMultilineExpressionChainComponents: self
          .lineBreakAroundMultilineExpressionChainComponents)
    }
    set {
      self.maximumBlankLines = newValue.maximumBlankLines
      self.respectsExistingLineBreaks = newValue.respectsExistingLineBreaks
      self.lineBreakBeforeControlFlowKeywords = newValue.lineBreakBeforeControlFlowKeywords
      self.lineBreakBeforeEachArgument = newValue.lineBreakBeforeEachArgument
      self.lineBreakBeforeEachGenericRequirement = newValue.lineBreakBeforeEachGenericRequirement
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
    set { self.fileScopedDeclarationPrivacy.accessLevel = newValue.accessLevel }
  }
}

public let settingsViewReducer = Reducer<SettingsViewState, SettingsViewAction, Void>.combine(
  indentationViewReducer.pullback(
    state: \SettingsViewState.indentationView, action: /SettingsViewAction.indentationView,
    environment: {}),
  tabWidthViewReducer.pullback(
    state: \SettingsViewState.tabWidthView, action: /SettingsViewAction.tabWidthView,
    environment: {}),
  lineLengthViewReducer.pullback(
    state: \SettingsViewState.lineLengthView, action: /SettingsViewAction.lineLengthView,
    environment: {}),
  lineBreaksViewReducer.pullback(
    state: \SettingsViewState.lineBreaksView, action: /SettingsViewAction.lineBreaksView,
    environment: {}),
  fileScopedDeclarationPrivacyViewReducer.pullback(
    state: \SettingsViewState.fileScopedDeclarationPrivacyView,
    action: /SettingsViewAction.fileScopedDeclarationPrivacyView, environment: {}))

public struct SettingsView: View {
  let store: Store<SettingsViewState, SettingsViewAction>
  public init(store: Store<SettingsViewState, SettingsViewAction>) { self.store = store }
  public var indentationView: some View {
    WithViewStore(self.store) { viewStore in
      HStack(alignment: .centerAlignmentGuide) {
        Text("Indentation:").modifier(TrailingAlignmentStyle()).modifier(CenterAlignmentStyle())
        VStack(alignment: .leading, spacing: .grid(2)) {
          HStack {
            Text("Length:").modifier(CenterAlignmentStyle())
            HStack(spacing: 0) {
              Stepper(
                onIncrement: { viewStore.send(.indentationView(.indentationIncremented)) },
                onDecrement: { viewStore.send(.indentationView(.indentationDecremented)) },
                label: {
                  TextField(
                    "",
                    value: Binding(
                      get: { viewStore.indentation.count },
                      set: { viewStore.send(.indentationView(.indentationCountFilledOut($0))) }),
                    formatter: UIntNumberFormatter()
                  ).modifier(PrimaryTextFieldStyle())
                }
              ).toolTip("The amount of whitespace that should be added when indenting one level")
              Picker(
                "",
                selection: Binding(
                  get: { viewStore.indentation },
                  set: { viewStore.send(.indentationView(.indentationSelected($0))) })
              ) {
                Text(Indent.spaces(Int()).rawValue).tag(Indent.spaces(viewStore.indentation.count))
                Text(Indent.tabs(Int()).rawValue).tag(Indent.tabs(viewStore.indentation.count))
              }.toolTip("The type of whitespace that should be added when indenting").modifier(
                PrimaryPickerStyle())
            }
          }
          Toggle(
            isOn: Binding(
              get: { viewStore.indentConditionalCompilationBlocks },
              set: {
                viewStore.send(.indentationView(.indentConditionalCompilationBlocksFilledOut($0)))
              })
          ) { Text("Indent conditional compilation blocks") }.toolTip(
            "Determines if conditional compilation blocks are indented. If this setting is false the body of #if, #elseif, and #else is not indented."
          )
          Toggle(
            isOn: Binding(
              get: { viewStore.indentSwitchCaseLabels },
              set: { viewStore.send(.indentationView(.indentSwitchCaseLabelsFilledOut($0))) })
          ) { Text("Indent switch case labels") }.toolTip(
            "Determines if `case` statements should be indented compared to the containing `switch` block"
          )
        }
      }
    }
  }
  public var tabWidthView: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        Text("Tab Width:").modifier(TrailingAlignmentStyle())
        Stepper(
          onIncrement: { viewStore.send(.tabWidthView(.tabWidthIncremented)) },
          onDecrement: { viewStore.send(.tabWidthView(.tabWidthDecremented)) },
          label: {
            TextField(
              "",
              value: Binding(
                get: { viewStore.tabWidth },
                set: { viewStore.send(.tabWidthView(.tabWidthFilledOut($0))) }),
              formatter: UIntNumberFormatter()
            ).modifier(PrimaryTextFieldStyle())
          }
        ).toolTip(
          "The number of spaces that should be considered equivalent to one tab character. This is used during line length calculations when tabs are used for indentation."
        )
        Text("spaces")
      }
    }
  }
  public var lineLenghtView: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        Text("Line Length:").modifier(TrailingAlignmentStyle())
        Stepper(
          onIncrement: { viewStore.send(.lineLengthView(.lineLengthIncremented)) },
          onDecrement: { viewStore.send(.lineLengthView(.lineLengthDecremented)) },
          label: {
            TextField(
              "",
              value: Binding(
                get: { viewStore.lineLength },
                set: { viewStore.send(.lineLengthView(.lineLengthFilledOut($0))) }),
              formatter: UIntNumberFormatter()
            ).modifier(PrimaryTextFieldStyle())
          }
        ).toolTip("The maximum allowed length of a line, in characters")
      }
    }
  }
  public var lineBreaksView: some View {
    WithViewStore(self.store) { viewStore in
      HStack(alignment: .firstTextBaseline) {
        Text("Line breaks:").modifier(TrailingAlignmentStyle())
        VStack(alignment: .leading, spacing: .grid(2)) {
          Toggle(
            isOn: Binding(
              get: { viewStore.respectsExistingLineBreaks },
              set: { viewStore.send(.lineBreaksView(.respectsExistingLineBreaksFilledOut($0))) })
          ) { Text("Respects existing line breaks") }.toolTip(
            "Indicates whether or not existing line breaks in the source code should be honored (if they are valid according to the style guidelines being enforced). If this settings is false, then the formatter will be more opinionated by only inserting line breaks where absolutely necessary and removing any others, effectively canonicalizing the output."
          )
          Toggle(
            isOn: Binding(
              get: { viewStore.lineBreakBeforeControlFlowKeywords },
              set: {
                viewStore.send(.lineBreaksView(.lineBreakBeforeControlFlowKeywordsFilledOut($0)))
              })
          ) { Text("Line break before control flow keywords") }.toolTip(
            "Determines the line-breaking behavior for control flow keywords that follow a closing brace, like else and catch. If true, a line break will be added before the keyword, forcing it onto its own line. If false, the keyword will be placed after the closing brace (separated by a space)."
          )
          Toggle(
            isOn: Binding(
              get: { viewStore.lineBreakBeforeEachArgument },
              set: { viewStore.send(.lineBreaksView(.lineBreakBeforeEachArgumentFilledOut($0))) })
          ) { Text("Line break before each argument") }.toolTip(
            "Determines the line-breaking behavior for generic arguments and function arguments when a declaration is wrapped onto multiple lines. If true, a line break will be added before each argument, forcing the entire argument list to be laid out vertically. If false, arguments will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(
            isOn: Binding(
              get: { viewStore.lineBreakBeforeEachGenericRequirement },
              set: {
                viewStore.send(.lineBreaksView(.lineBreakBeforeEachGenericRequirementFilledOut($0)))
              })
          ) { Text("Line break before each generic requirement") }.toolTip(
            "Determines the line-breaking behavior for generic requirements when the requirements list is wrapped onto multiple lines. If true, a line break will be added before each requirement, forcing the entire requirements list to be laid out vertically. If false, requirements will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(
            isOn: Binding(
              get: { viewStore.lineBreakAroundMultilineExpressionChainComponents },
              set: {
                viewStore.send(
                  .lineBreaksView(.lineBreakAroundMultilineExpressionChainComponentsFilledOut($0)))
              })
          ) { Text("Line break around multiline expression chain components") }.toolTip(
            "Determines whether line breaks should be forced before and after multiline components of dot-chained expressions, such as function calls and subscripts chained together through member access (i.e. \".\" expressions). When any component is multiline and this option is true, a line break is forced before the \".\" of the component and after the component's closing delimiter (i.e. right paren, right bracket, right brace, etc.)."
          )
          Toggle(
            isOn: Binding(
              get: { viewStore.prioritizeKeepingFunctionOutputTogether },
              set: {
                viewStore.send(
                  .lineBreaksView(.prioritizeKeepingFunctionOutputTogetherFilledOut($0)))
              })
          ) { Text("Prioritize keeping function output together") }.toolTip(
            "Determines if function-like declaration outputs should be prioritized to be together with the function signature right (closing) parenthesis. If false, function output (i.e. throws, return type) is not prioritized to be together with the signature's right parenthesis, and when the line length would be exceeded, a line break will be fired after the function signature first, indenting the declaration output one additional level. If true, A line break will be fired further up in the function's declaration (e.g. generic parameters, parameters) before breaking on the function's output."
          )
          HStack {
            Text("Maximum blank lines")
            Stepper(
              onIncrement: { viewStore.send(.lineBreaksView(.maximumBlankLinesIncremented)) },
              onDecrement: { viewStore.send(.lineBreaksView(.maximumBlankLinesDecremented)) },
              label: {
                TextField(
                  "",
                  value: Binding(
                    get: { viewStore.maximumBlankLines },
                    set: { viewStore.send(.lineBreaksView(.maximumBlankLinesFilledOut($0))) }),
                  formatter: UIntNumberFormatter()
                ).modifier(PrimaryTextFieldStyle())
              }
            ).toolTip(
              "The maximum number of consecutive blank lines that are allowed to be present in a source file. Any number larger than this will be collapsed down to the maximum."
            )
          }
        }
      }
    }
  }

  public var fileScopedDeclarationPrivacyView: some View {
    WithViewStore(self.store) { viewStore in
      HStack(alignment: .centerAlignmentGuide, spacing: 0) {
        Text("File Scoped Declaration Privacy:").modifier(TrailingAlignmentStyle()).modifier(
          CenterAlignmentStyle())
        Picker(
          "",
          selection: Binding(
            get: { viewStore.fileScopedDeclarationPrivacy.accessLevel },
            set: { viewStore.send(.fileScopedDeclarationPrivacyView(.accessLevelSelected($0))) })
        ) {
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.`private`.rawValue).tag(
            FileScopedDeclarationPrivacyConfiguration.AccessLevel.`private`)
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.`fileprivate`.rawValue).tag(
            FileScopedDeclarationPrivacyConfiguration.AccessLevel.`fileprivate`)
        }.toolTip(
          "Determines the formal access level (i.e., the level specified in source code) for file-scoped declarations whose effective access level is private to the containing file."
        ).modifier(PrimaryPickerStyle())
      }
    }
  }

  public var body: some View {
    WithViewStore(self.store) { _ in
      VStack(alignment: .trailingAlignmentGuide, spacing: .grid(4)) {
        indentationView
        tabWidthView
        lineLenghtView
        lineBreaksView
        fileScopedDeclarationPrivacyView
      }.modifier(PrimaryVStackStyle())
    }
  }
}

// MARK: Indentation

extension Indent: RawRepresentable {
  public typealias RawValue = String

  public init?(rawValue: RawValue) { return nil }

  public var rawValue: RawValue {
    switch self {
    case .spaces: return "Spaces"
    case .tabs: return "Tabs"
    }
  }

  public var count: Int {
    get {
      switch self {
      case .spaces(let count): return count
      case .tabs(let count): return count
      }
    }
    set {
      switch self {
      case .spaces: self = .spaces(newValue)
      case .tabs: self = .tabs(newValue)
      }
    }
  }
}

public enum IndentationViewAction: Equatable {
  case indentationSelected(Indent)
  case indentationCountFilledOut(Int)
  case indentationIncremented
  case indentationDecremented
  case indentConditionalCompilationBlocksFilledOut(Bool)
  case indentSwitchCaseLabelsFilledOut(Bool)
}

public struct IndentationViewState: Equatable {
  public var indentation: Indent
  public var indentConditionalCompilationBlocks: Bool
  public var indentSwitchCaseLabels: Bool

  public init(
    indentation: Indent, indentConditionalCompilationBlocks: Bool, indentSwitchCaseLabels: Bool
  ) {
    self.indentation = indentation
    self.indentConditionalCompilationBlocks = indentConditionalCompilationBlocks
    self.indentSwitchCaseLabels = indentSwitchCaseLabels
  }
}

public let indentationViewReducer = Reducer<IndentationViewState, IndentationViewAction, Void> {
  state, action, _ in
  switch action {
  case .indentationSelected(let value):
    state.indentation = value
    return .none
  case .indentationCountFilledOut(let value):
    state.indentation.count = value
    return .none
  case .indentationIncremented:
    state.indentation.count += 1
    return .none
  case .indentationDecremented:
    state.indentation.count -= 1
    return .none
  case .indentConditionalCompilationBlocksFilledOut(let value):
    state.indentConditionalCompilationBlocks = value
    return .none
  case .indentSwitchCaseLabelsFilledOut(let value):
    state.indentSwitchCaseLabels = value
    return .none
  }
}

// MARK: TabWidth

public enum TabWidthViewAction: Equatable {
  case tabWidthFilledOut(Int)
  case tabWidthIncremented
  case tabWidthDecremented
}

public struct TabWidthViewState {
  public var tabWidth: Int

  public init(tabWidth: Int) { self.tabWidth = tabWidth }
}

public let tabWidthViewReducer = Reducer<TabWidthViewState, TabWidthViewAction, Void> {
  state, action, _ in
  switch action {
  case .tabWidthFilledOut(let value):
    state.tabWidth = value
    return .none
  case .tabWidthIncremented:
    state.tabWidth += 1
    return .none
  case .tabWidthDecremented:
    state.tabWidth -= 1
    return .none
  }
}

// MARK: LineLength

public enum LineLengthViewAction: Equatable {
  case lineLengthFilledOut(Int)
  case lineLengthIncremented
  case lineLengthDecremented
}

public struct LineLengthViewState {
  public var lineLength: Int

  public init(lineLength: Int) { self.lineLength = lineLength }
}

public let lineLengthViewReducer = Reducer<LineLengthViewState, LineLengthViewAction, Void> {
  state, action, _ in
  switch action {
  case .lineLengthFilledOut(let value):
    state.lineLength = value
    return .none
  case .lineLengthIncremented:
    state.lineLength += 1
    return .none
  case .lineLengthDecremented:
    state.lineLength -= 1
    return .none
  }
}

// MARK: LineBreaks

public enum LineBreaksViewAction: Equatable {
  case maximumBlankLinesFilledOut(Int)
  case maximumBlankLinesIncremented
  case maximumBlankLinesDecremented
  case respectsExistingLineBreaksFilledOut(Bool)
  case lineBreakBeforeControlFlowKeywordsFilledOut(Bool)
  case lineBreakBeforeEachArgumentFilledOut(Bool)
  case lineBreakBeforeEachGenericRequirementFilledOut(Bool)
  case prioritizeKeepingFunctionOutputTogetherFilledOut(Bool)
  case lineBreakAroundMultilineExpressionChainComponentsFilledOut(Bool)
}

public struct LineBreaksViewState {
  public var maximumBlankLines: Int
  public var respectsExistingLineBreaks: Bool
  public var lineBreakBeforeControlFlowKeywords: Bool
  public var lineBreakBeforeEachArgument: Bool
  public var lineBreakBeforeEachGenericRequirement: Bool
  public var prioritizeKeepingFunctionOutputTogether: Bool
  public var lineBreakAroundMultilineExpressionChainComponents: Bool

  public init(
    maximumBlankLines: Int, respectsExistingLineBreaks: Bool,
    lineBreakBeforeControlFlowKeywords: Bool, lineBreakBeforeEachArgument: Bool,
    lineBreakBeforeEachGenericRequirement: Bool, prioritizeKeepingFunctionOutputTogether: Bool,
    lineBreakAroundMultilineExpressionChainComponents: Bool
  ) {
    self.maximumBlankLines = maximumBlankLines
    self.respectsExistingLineBreaks = respectsExistingLineBreaks
    self.lineBreakBeforeControlFlowKeywords = lineBreakBeforeControlFlowKeywords
    self.lineBreakBeforeEachArgument = lineBreakBeforeEachArgument
    self.lineBreakBeforeEachGenericRequirement = lineBreakBeforeEachGenericRequirement
    self.prioritizeKeepingFunctionOutputTogether = prioritizeKeepingFunctionOutputTogether
    self.lineBreakAroundMultilineExpressionChainComponents =
      lineBreakAroundMultilineExpressionChainComponents
  }
}

public let lineBreaksViewReducer = Reducer<LineBreaksViewState, LineBreaksViewAction, Void> {
  state, action, _ in
  switch action {
  case .maximumBlankLinesFilledOut(let value):
    state.maximumBlankLines = value
    return .none
  case .maximumBlankLinesIncremented:
    state.maximumBlankLines += 1
    return .none
  case .maximumBlankLinesDecremented:
    state.maximumBlankLines -= 1
    return .none
  case .respectsExistingLineBreaksFilledOut(let value):
    state.respectsExistingLineBreaks = value
    return .none
  case .lineBreakBeforeControlFlowKeywordsFilledOut(let value):
    state.lineBreakBeforeControlFlowKeywords = value
    return .none
  case .lineBreakBeforeEachArgumentFilledOut(let value):
    state.lineBreakBeforeEachArgument = value
    return .none
  case .lineBreakBeforeEachGenericRequirementFilledOut(let value):
    state.lineBreakBeforeEachGenericRequirement = value
    return .none
  case .prioritizeKeepingFunctionOutputTogetherFilledOut(let value):
    state.prioritizeKeepingFunctionOutputTogether = value
    return .none
  case .lineBreakAroundMultilineExpressionChainComponentsFilledOut(let value):
    state.lineBreakAroundMultilineExpressionChainComponents = value
    return .none
  }
}

// MARK: FileScopedDeclarationPrivacy

extension FileScopedDeclarationPrivacyConfiguration.AccessLevel {
  public typealias RawValue = String

  public init?(rawValue: RawValue) { return nil }

  public var rawValue: RawValue {
    switch self {
    case .`private`: return "Private"
    case .`fileprivate`: return "Fileprivate"
    }
  }
}

public enum FileScopedDeclarationPrivacyViewAction: Equatable {
  case accessLevelSelected(FileScopedDeclarationPrivacyConfiguration.AccessLevel)
}

public struct FileScopedDeclarationPrivacyViewState {
  public var accessLevel: FileScopedDeclarationPrivacyConfiguration.AccessLevel

  public init(accessLevel: FileScopedDeclarationPrivacyConfiguration.AccessLevel) {
    self.accessLevel = accessLevel
  }
}

public let fileScopedDeclarationPrivacyViewReducer = Reducer<
  FileScopedDeclarationPrivacyViewState, FileScopedDeclarationPrivacyViewAction, Void
> { state, action, _ in
  switch action {
  case .accessLevelSelected(let value):
    state.accessLevel = value
    return .none
  }
}
