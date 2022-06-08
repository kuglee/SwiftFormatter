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

public let settingsViewReducer = combine(
  pullback(
    indentationViewReducer, value: \SettingsViewState.indentationView,
    action: /SettingsViewAction.indentationView),
  pullback(
    tabWidthViewReducer, value: \SettingsViewState.tabWidthView,
    action: /SettingsViewAction.tabWidthView),
  pullback(
    lineLengthViewReducer, value: \SettingsViewState.lineLengthView,
    action: /SettingsViewAction.lineLengthView),
  pullback(
    lineBreaksViewReducer, value: \SettingsViewState.lineBreaksView,
    action: /SettingsViewAction.lineBreaksView),
  pullback(
    fileScopedDeclarationPrivacyViewReducer,
    value: \SettingsViewState.fileScopedDeclarationPrivacyView,
    action: /SettingsViewAction.fileScopedDeclarationPrivacyView))

public struct SettingsView: View {
  @ObservedObject var store: Store<SettingsViewState, SettingsViewAction>

  public init(store: Store<SettingsViewState, SettingsViewAction>) { self.store = store }
  public var indentationView: some View {
    HStack(alignment: .centerAlignmentGuide) {
      Text("Indentation:").modifier(TrailingAlignmentStyle()).modifier(CenterAlignmentStyle())
      VStack(alignment: .leading, spacing: .grid(2)) {
        HStack {
          Text("Length:").modifier(CenterAlignmentStyle())
          HStack(spacing: 0) {
            Stepper(
              onIncrement: { self.store.send(.indentationView(.indentationIncremented)) },
              onDecrement: { self.store.send(.indentationView(.indentationDecremented)) },
              label: {
                TextField(
                  "",
                  value: Binding(
                    get: { self.store.value.indentation.count },
                    set: { self.store.send(.indentationView(.indentationCountFilledOut($0))) }),
                  formatter: UIntNumberFormatter()
                ).modifier(PrimaryTextFieldStyle())
              }
            ).toolTip("The amount of whitespace that should be added when indenting one level")
            Picker(
              "",
              selection: Binding(
                get: { self.store.value.indentation },
                set: { self.store.send(.indentationView(.indentationSelected($0))) })
            ) {
              Text(Indent.spaces(Int()).rawValue).tag(
                Indent.spaces(self.store.value.indentation.count))
              Text(Indent.tabs(Int()).rawValue).tag(Indent.tabs(self.store.value.indentation.count))
            }.toolTip("The type of whitespace that should be added when indenting").modifier(
              PrimaryPickerStyle())
          }
        }
        Toggle(
          isOn: Binding(
            get: { self.store.value.indentConditionalCompilationBlocks },
            set: {
              self.store.send(.indentationView(.indentConditionalCompilationBlocksFilledOut($0)))
            })
        ) { Text("Indent conditional compilation blocks") }.toolTip(
          "Determines if conditional compilation blocks are indented. If this setting is false the body of #if, #elseif, and #else is not indented."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.indentSwitchCaseLabels },
            set: { self.store.send(.indentationView(.indentSwitchCaseLabelsFilledOut($0))) })
        ) { Text("Indent switch case labels") }.toolTip(
          "Determines if `case` statements should be indented compared to the containing `switch` block"
        )
      }
    }
  }
  public var tabWidthView: some View {
    HStack {
      Text("Tab Width:").modifier(TrailingAlignmentStyle())
      Stepper(
        onIncrement: { self.store.send(.tabWidthView(.tabWidthIncremented)) },
        onDecrement: { self.store.send(.tabWidthView(.tabWidthDecremented)) },
        label: {
          TextField(
            "",
            value: Binding(
              get: { self.store.value.tabWidth },
              set: { self.store.send(.tabWidthView(.tabWidthFilledOut($0))) }),
            formatter: UIntNumberFormatter()
          ).modifier(PrimaryTextFieldStyle())
        }
      ).toolTip(
        "The number of spaces that should be considered equivalent to one tab character. This is used during line length calculations when tabs are used for indentation."
      )
      Text("spaces")
    }
  }
  public var lineLenghtView: some View {
    HStack {
      Text("Line Length:").modifier(TrailingAlignmentStyle())
      Stepper(
        onIncrement: { self.store.send(.lineLengthView(.lineLengthIncremented)) },
        onDecrement: { self.store.send(.lineLengthView(.lineLengthDecremented)) },
        label: {
          TextField(
            "",
            value: Binding(
              get: { self.store.value.lineLength },
              set: { self.store.send(.lineLengthView(.lineLengthFilledOut($0))) }),
            formatter: UIntNumberFormatter()
          ).modifier(PrimaryTextFieldStyle())
        }
      ).toolTip("The maximum allowed length of a line, in characters")
    }
  }
  public var lineBreaksView: some View {
    HStack(alignment: .firstTextBaseline) {
      Text("Line breaks:").modifier(TrailingAlignmentStyle())
      VStack(alignment: .leading, spacing: .grid(2)) {
        Toggle(
          isOn: Binding(
            get: { self.store.value.respectsExistingLineBreaks },
            set: { self.store.send(.lineBreaksView(.respectsExistingLineBreaksFilledOut($0))) })
        ) { Text("Respects existing line breaks") }.toolTip(
          "Indicates whether or not existing line breaks in the source code should be honored (if they are valid according to the style guidelines being enforced). If this settings is false, then the formatter will be more opinionated by only inserting line breaks where absolutely necessary and removing any others, effectively canonicalizing the output."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.lineBreakBeforeControlFlowKeywords },
            set: {
              self.store.send(.lineBreaksView(.lineBreakBeforeControlFlowKeywordsFilledOut($0)))
            })
        ) { Text("Line break before control flow keywords") }.toolTip(
          "Determines the line-breaking behavior for control flow keywords that follow a closing brace, like else and catch. If true, a line break will be added before the keyword, forcing it onto its own line. If false, the keyword will be placed after the closing brace (separated by a space)."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.lineBreakBeforeEachArgument },
            set: { self.store.send(.lineBreaksView(.lineBreakBeforeEachArgumentFilledOut($0))) })
        ) { Text("Line break before each argument") }.toolTip(
          "Determines the line-breaking behavior for generic arguments and function arguments when a declaration is wrapped onto multiple lines. If true, a line break will be added before each argument, forcing the entire argument list to be laid out vertically. If false, arguments will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.lineBreakBeforeEachGenericRequirement },
            set: {
              self.store.send(.lineBreaksView(.lineBreakBeforeEachGenericRequirementFilledOut($0)))
            })
        ) { Text("Line break before each generic requirement") }.toolTip(
          "Determines the line-breaking behavior for generic requirements when the requirements list is wrapped onto multiple lines. If true, a line break will be added before each requirement, forcing the entire requirements list to be laid out vertically. If false, requirements will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.lineBreakAroundMultilineExpressionChainComponents },
            set: {
              self.store.send(
                .lineBreaksView(.lineBreakAroundMultilineExpressionChainComponentsFilledOut($0)))
            })
        ) { Text("Line break around multiline expression chain components") }.toolTip(
          "Determines whether line breaks should be forced before and after multiline components of dot-chained expressions, such as function calls and subscripts chained together through member access (i.e. \".\" expressions). When any component is multiline and this option is true, a line break is forced before the \".\" of the component and after the component's closing delimiter (i.e. right paren, right bracket, right brace, etc.)."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.prioritizeKeepingFunctionOutputTogether },
            set: {
              self.store.send(
                .lineBreaksView(.prioritizeKeepingFunctionOutputTogetherFilledOut($0)))
            })
        ) { Text("Prioritize keeping function output together") }.toolTip(
          "Determines if function-like declaration outputs should be prioritized to be together with the function signature right (closing) parenthesis. If false, function output (i.e. throws, return type) is not prioritized to be together with the signature's right parenthesis, and when the line length would be exceeded, a line break will be fired after the function signature first, indenting the declaration output one additional level. If true, A line break will be fired further up in the function's declaration (e.g. generic parameters, parameters) before breaking on the function's output."
        )
        HStack {
          Text("Maximum blank lines")
          Stepper(
            onIncrement: { self.store.send(.lineBreaksView(.maximumBlankLinesIncremented)) },
            onDecrement: { self.store.send(.lineBreaksView(.maximumBlankLinesDecremented)) },
            label: {
              TextField(
                "",
                value: Binding(
                  get: { self.store.value.maximumBlankLines },
                  set: { self.store.send(.lineBreaksView(.maximumBlankLinesFilledOut($0))) }),
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
  public var fileScopedDeclarationPrivacyView: some View {
    HStack(alignment: .centerAlignmentGuide, spacing: 0) {
      Text("File Scoped Declaration Privacy:").modifier(TrailingAlignmentStyle()).modifier(
        CenterAlignmentStyle())
      Picker(
        "",
        selection: Binding(
          get: { self.store.value.fileScopedDeclarationPrivacy.accessLevel },
          set: { self.store.send(.fileScopedDeclarationPrivacyView(.accessLevelSelected($0))) })
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

  public var body: some View {
    VStack(alignment: .trailingAlignmentGuide, spacing: .grid(4)) {
      indentationView
      tabWidthView
      lineLenghtView
      lineBreaksView
      fileScopedDeclarationPrivacyView
    }.modifier(PrimaryVStackStyle())
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

public struct IndentationViewState {
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

public func indentationViewReducer(state: inout IndentationViewState, action: IndentationViewAction)
  -> [Effect<IndentationViewAction>]
{
  switch action {
  case .indentationSelected(let value): state.indentation = value
  case .indentationCountFilledOut(let value): state.indentation.count = value
  case .indentationIncremented: state.indentation.count += 1
  case .indentationDecremented: state.indentation.count -= 1
  case .indentConditionalCompilationBlocksFilledOut(let value):
    state.indentConditionalCompilationBlocks = value
  case .indentSwitchCaseLabelsFilledOut(let value): state.indentSwitchCaseLabels = value
  }

  return []
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

public func tabWidthViewReducer(state: inout TabWidthViewState, action: TabWidthViewAction)
  -> [Effect<TabWidthViewAction>]
{
  switch action {
  case .tabWidthFilledOut(let value): state.tabWidth = value
  case .tabWidthIncremented: state.tabWidth += 1
  case .tabWidthDecremented: state.tabWidth -= 1
  }

  return []
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

public func lineLengthViewReducer(state: inout LineLengthViewState, action: LineLengthViewAction)
  -> [Effect<LineLengthViewAction>]
{
  switch action {
  case .lineLengthFilledOut(let value): state.lineLength = value
  case .lineLengthIncremented: state.lineLength += 1
  case .lineLengthDecremented: state.lineLength -= 1
  }

  return []
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

public func lineBreaksViewReducer(state: inout LineBreaksViewState, action: LineBreaksViewAction)
  -> [Effect<LineBreaksViewAction>]
{
  switch action {
  case .maximumBlankLinesFilledOut(let value): state.maximumBlankLines = value
  case .maximumBlankLinesIncremented: state.maximumBlankLines += 1
  case .maximumBlankLinesDecremented: state.maximumBlankLines -= 1
  case .respectsExistingLineBreaksFilledOut(let value): state.respectsExistingLineBreaks = value
  case .lineBreakBeforeControlFlowKeywordsFilledOut(let value):
    state.lineBreakBeforeControlFlowKeywords = value
  case .lineBreakBeforeEachArgumentFilledOut(let value): state.lineBreakBeforeEachArgument = value
  case .lineBreakBeforeEachGenericRequirementFilledOut(let value):
    state.lineBreakBeforeEachGenericRequirement = value
  case .prioritizeKeepingFunctionOutputTogetherFilledOut(let value):
    state.prioritizeKeepingFunctionOutputTogether = value
  case .lineBreakAroundMultilineExpressionChainComponentsFilledOut(let value):
    state.lineBreakAroundMultilineExpressionChainComponents = value
  }

  return []
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

public func fileScopedDeclarationPrivacyViewReducer(
  state: inout FileScopedDeclarationPrivacyViewState, action: FileScopedDeclarationPrivacyViewAction
) -> [Effect<FileScopedDeclarationPrivacyViewAction>] {
  switch action {
  case .accessLevelSelected(let value): state.accessLevel = value
  }

  return []
}
