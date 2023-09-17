import ComposableArchitecture
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI

public struct FormatterSettings: Reducer {
  public init() {}

  public struct State: Equatable {
    @BindingState public var maximumBlankLines: Int
    @BindingState public var lineLength: Int
    @BindingState public var tabWidth: Int
    @BindingState public var indentation: Indent
    @BindingState public var respectsExistingLineBreaks: Bool
    @BindingState public var lineBreakBeforeControlFlowKeywords: Bool
    @BindingState public var lineBreakBeforeEachArgument: Bool
    @BindingState public var lineBreakBeforeEachGenericRequirement: Bool
    @BindingState public var prioritizeKeepingFunctionOutputTogether: Bool
    @BindingState public var indentConditionalCompilationBlocks: Bool
    @BindingState public var indentSwitchCaseLabels: Bool
    @BindingState public var lineBreakAroundMultilineExpressionChainComponents: Bool
    @BindingState public var fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration
    @BindingState public var shouldTrimTrailingWhitespace: Bool

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
      indentSwitchCaseLabels: Bool,
      lineBreakAroundMultilineExpressionChainComponents: Bool,
      fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration,
      shouldTrimTrailingWhitespace: Bool
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
      self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
    }
  }

  public enum Action: Equatable, BindableAction { case binding(BindingAction<State>) }

  public var body: some ReducerOf<Self> { BindingReducer() }
}

public struct FormatterSettingsView: View {
  let store: StoreOf<FormatterSettings>

  public init(store: StoreOf<FormatterSettings>) { self.store = store }

  @MainActor public var indentationView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .centerNonSiblings) {
        Text("Indentation:").alignmentGuide(.trailingLabel) { $0[.trailing] }
          .alignmentGuide(.centerNonSiblings) { $0[VerticalAlignment.center] }
        VStack(alignment: .leading, spacing: .grid(1)) {
          HStack(spacing: 0) {
            Text("Length:").alignmentGuide(.centerNonSiblings) { $0[VerticalAlignment.center] }
            Stepper(
              value: viewStore.$indentation.count,
              in: 0...1000,
              step: 1,
              label: { StepperTextField(value: viewStore.$indentation.count) }
            )
            .help("The amount of whitespace that should be added when indenting one level")
            Picker("", selection: viewStore.$indentation) {
              Text(Indent.spaces(Int()).rawValue).tag(Indent.spaces(viewStore.indentation.count))
              Text(Indent.tabs(Int()).rawValue).tag(Indent.tabs(viewStore.indentation.count))
            }
            .help("The type of whitespace that should be added when indenting").fixedSize()
          }
          Toggle(isOn: viewStore.$indentConditionalCompilationBlocks) {
            Text("Indent conditional compilation blocks")
          }
          .help(
            "Determines if conditional compilation blocks are indented. If this setting is false the body of #if, #elseif, and #else is not indented."
          )
          Toggle(isOn: viewStore.$indentSwitchCaseLabels) { Text("Indent switch case labels") }
            .help(
              "Determines if case statements should be indented compared to the containing switch block"
            )
        }
      }
    }
  }

  @MainActor public var tabWidthView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(spacing: 0) {
        Text("Tab Width:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        Stepper(
          value: viewStore.$tabWidth,
          in: 0...1000,
          step: 1,
          label: { StepperTextField(value: viewStore.$tabWidth) }
        )
        .help(
          "The number of spaces that should be considered equivalent to one tab character. This is used during line length calculations when tabs are used for indentation."
        )
        Text("spaces").padding(.grid(2))
      }
    }
  }

  @MainActor public var lineLenghtView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(spacing: 0) {
        Text("Line Length:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        Stepper(
          value: viewStore.$lineLength,
          in: 0...1000,
          step: 1,
          label: { StepperTextField(value: viewStore.$lineLength) }
        )
        .help("The maximum allowed length of a line, in characters")
      }
    }
  }

  @MainActor public var lineBreaksView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .firstTextBaseline) {
        Text("Line Breaks:").alignmentGuide(.trailingLabel) { $0[.trailing] }
        VStack(alignment: .leading, spacing: .grid(1)) {
          Toggle(isOn: viewStore.$respectsExistingLineBreaks) {
            Text("Respects existing line breaks")
          }
          .help(
            "Indicates whether or not existing line breaks in the source code should be honored (if they are valid according to the style guidelines being enforced). If this settings is false, then the formatter will be more opinionated by only inserting line breaks where absolutely necessary and removing any others, effectively canonicalizing the output."
          )
          Toggle(isOn: viewStore.$lineBreakBeforeControlFlowKeywords) {
            Text("Line break before control flow keywords")
          }
          .help(
            "Determines the line-breaking behavior for control flow keywords that follow a closing brace, like else and catch. If true, a line break will be added before the keyword, forcing it onto its own line. If false, the keyword will be placed after the closing brace (separated by a space)."
          )
          Toggle(isOn: viewStore.$lineBreakBeforeEachArgument) {
            Text("Line break before each argument")
          }
          .help(
            "Determines the line-breaking behavior for generic arguments and function arguments when a declaration is wrapped onto multiple lines. If true, a line break will be added before each argument, forcing the entire argument list to be laid out vertically. If false, arguments will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(isOn: viewStore.$lineBreakBeforeEachGenericRequirement) {
            Text("Line break before each generic requirement")
          }
          .help(
            "Determines the line-breaking behavior for generic requirements when the requirements list is wrapped onto multiple lines. If true, a line break will be added before each requirement, forcing the entire requirements list to be laid out vertically. If false, requirements will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(isOn: viewStore.$lineBreakAroundMultilineExpressionChainComponents) {
            Text("Line break around multiline expression chain components")
          }
          .help(
            "Determines whether line breaks should be forced before and after multiline components of dot-chained expressions, such as function calls and subscripts chained together through member access (i.e. \".\" expressions). When any component is multiline and this option is true, a line break is forced before the \".\" of the component and after the component's closing delimiter (i.e. right paren, right bracket, right brace, etc.)."
          )
          Toggle(isOn: viewStore.$prioritizeKeepingFunctionOutputTogether) {
            Text("Prioritize keeping function output together")
          }
          .help(
            "Determines if function-like declaration outputs should be prioritized to be together with the function signature right (closing) parenthesis. If false, function output (i.e. throws, return type) is not prioritized to be together with the signature's right parenthesis, and when the line length would be exceeded, a line break will be fired after the function signature first, indenting the declaration output one additional level. If true, A line break will be fired further up in the function's declaration (e.g. generic parameters, parameters) before breaking on the function's output."
          )
          Toggle(isOn: viewStore.$shouldTrimTrailingWhitespace) {
            Text("Trim trailing whitespace before formatting")
          }
          .help(
            "The formatter trims trailing whitespace before formatting, so whitespace only lines won't get joined with the subsequent line."
          )
          HStack(spacing: 0) {
            Text("Maximum blank lines")
            Stepper(
              value: viewStore.$maximumBlankLines,
              in: 0...1000,
              step: 1,
              label: { StepperTextField(value: viewStore.$maximumBlankLines) }
            )
            .help(
              "The maximum number of consecutive blank lines that are allowed to be present in a source file. Any number larger than this will be collapsed down to the maximum."
            )
          }
        }
      }
    }
  }

  @MainActor public var fileScopedDeclarationPrivacyView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .centerNonSiblings, spacing: 0) {
        Text("File Scoped Declaration Privacy:").alignmentGuide(.trailingLabel) { $0[.trailing] }
          .alignmentGuide(.centerNonSiblings) { $0[VerticalAlignment.center] }
        Picker("", selection: viewStore.$fileScopedDeclarationPrivacy.accessLevel) {
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.private.rawValue)
            .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.private)
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.fileprivate.rawValue)
            .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.fileprivate)
        }
        .help(
          "Determines the formal access level (i.e., the level specified in source code) for file-scoped declarations whose effective access level is private to the containing file."
        )
        .fixedSize()
      }
    }
  }

  @FocusState var shouldFocusFirstTextField: Bool
  public var body: some View {
    VStack(alignment: .trailingLabel, spacing: .grid(2)) {
      indentationView
      tabWidthView
      lineLenghtView
      lineBreaksView
      fileScopedDeclarationPrivacyView
    }
    .multilineTextAlignment(.trailing)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .focused($shouldFocusFirstTextField).task { shouldFocusFirstTextField = false }
  }
}

extension Indent: RawRepresentable {
  public typealias RawValue = String

  public init?(rawValue: RawValue) { nil }

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
