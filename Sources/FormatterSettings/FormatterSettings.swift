import AppConstants
import ComposableArchitecture
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import Utility

public struct FormatterSettingsViewState: Equatable {
  @BindableState public var maximumBlankLines: Int
  @BindableState public var lineLength: Int
  @BindableState public var tabWidth: Int
  @BindableState public var indentation: Indent
  @BindableState public var respectsExistingLineBreaks: Bool
  @BindableState public var lineBreakBeforeControlFlowKeywords: Bool
  @BindableState public var lineBreakBeforeEachArgument: Bool
  @BindableState public var lineBreakBeforeEachGenericRequirement: Bool
  @BindableState public var prioritizeKeepingFunctionOutputTogether: Bool
  @BindableState public var indentConditionalCompilationBlocks: Bool
  @BindableState public var indentSwitchCaseLabels: Bool
  @BindableState public var lineBreakAroundMultilineExpressionChainComponents: Bool
  @BindableState public var fileScopedDeclarationPrivacy: FileScopedDeclarationPrivacyConfiguration
  @BindableState public var shouldTrimTrailingWhitespace: Bool

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

public enum FormatterSettingsViewAction: Equatable, BindableAction {
  case binding(BindingAction<FormatterSettingsViewState>)
}

public let formatterSettingsViewReducer = Reducer<
  FormatterSettingsViewState, FormatterSettingsViewAction, Void
>
.empty.binding()

public struct FormatterSettingsView: View {
  let store: Store<FormatterSettingsViewState, FormatterSettingsViewAction>

  public init(store: Store<FormatterSettingsViewState, FormatterSettingsViewAction>) {
    self.store = store
  }

  public var indentationView: some View {
    WithViewStore(self.store) { viewStore in
      HStack(alignment: .centerAlignmentGuide) {
        Text("Indentation:").modifier(TrailingAlignmentStyle()).modifier(CenterAlignmentStyle())
        VStack(alignment: .leading, spacing: .grid(2)) {
          HStack(spacing: 0) {
            Text("Length:").modifier(CenterAlignmentStyle())
            Stepper(
              value: viewStore.binding(\.$indentation.count),
              in: 0...1000,
              step: 1,
              label: {
                TextField(
                  "",
                  value: viewStore.binding(\.$indentation.count),
                  formatter: uIntNumberFormatter
                )
                .modifier(PrimaryTextFieldStyle())
              }
            )
            .help("The amount of whitespace that should be added when indenting one level")
            Picker("", selection: viewStore.binding(\.$indentation)) {
              Text(Indent.spaces(Int()).rawValue).tag(Indent.spaces(viewStore.indentation.count))
              Text(Indent.tabs(Int()).rawValue).tag(Indent.tabs(viewStore.indentation.count))
            }

            .help("The type of whitespace that should be added when indenting")
            .modifier(PrimaryPickerStyle())
          }
          Toggle(isOn: viewStore.binding(\.$indentConditionalCompilationBlocks)) {
            Text("Indent conditional compilation blocks")
          }
          .help(
            "Determines if conditional compilation blocks are indented. If this setting is false the body of #if, #elseif, and #else is not indented."
          )
          Toggle(isOn: viewStore.binding(\.$indentSwitchCaseLabels)) {
            Text("Indent switch case labels")
          }
          .help(
            "Determines if case statements should be indented compared to the containing switch block"
          )
        }
      }
    }
  }

  public var tabWidthView: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 0) {
        Text("Tab Width:").modifier(TrailingAlignmentStyle())
        Stepper(
          value: viewStore.binding(\.$tabWidth),
          in: 0...1000,
          step: 1,
          label: {
            TextField("", value: viewStore.binding(\.$tabWidth), formatter: uIntNumberFormatter)
              .frame(alignment: .leading).modifier(PrimaryTextFieldStyle())
          }
        )
        .help(
          "The number of spaces that should be considered equivalent to one tab character. This is used during line length calculations when tabs are used for indentation."
        )
        Text("spaces")
      }
    }
  }

  public var lineLenghtView: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 0) {
        Text("Line Length:").modifier(TrailingAlignmentStyle())
        Stepper(
          value: viewStore.binding(\.$lineLength),
          in: 0...1000,
          step: 1,
          label: {
            TextField("", value: viewStore.binding(\.$lineLength), formatter: uIntNumberFormatter)
              .modifier(PrimaryTextFieldStyle())
          }
        )
        .help("The maximum allowed length of a line, in characters")
      }
    }
  }

  public var lineBreaksView: some View {
    WithViewStore(self.store) { viewStore in
      HStack(alignment: .firstTextBaseline) {
        Text("Line breaks:").modifier(TrailingAlignmentStyle())
        VStack(alignment: .leading, spacing: .grid(2)) {
          Toggle(isOn: viewStore.binding(\.$respectsExistingLineBreaks)) {
            Text("Respects existing line breaks")
          }
          .help(
            "Indicates whether or not existing line breaks in the source code should be honored (if they are valid according to the style guidelines being enforced). If this settings is false, then the formatter will be more opinionated by only inserting line breaks where absolutely necessary and removing any others, effectively canonicalizing the output."
          )
          Toggle(isOn: viewStore.binding(\.$lineBreakBeforeControlFlowKeywords)) {
            Text("Line break before control flow keywords")
          }
          .help(
            "Determines the line-breaking behavior for control flow keywords that follow a closing brace, like else and catch. If true, a line break will be added before the keyword, forcing it onto its own line. If false, the keyword will be placed after the closing brace (separated by a space)."
          )
          Toggle(isOn: viewStore.binding(\.$lineBreakBeforeEachArgument)) {
            Text("Line break before each argument")
          }
          .help(
            "Determines the line-breaking behavior for generic arguments and function arguments when a declaration is wrapped onto multiple lines. If true, a line break will be added before each argument, forcing the entire argument list to be laid out vertically. If false, arguments will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(isOn: viewStore.binding(\.$lineBreakBeforeEachGenericRequirement)) {
            Text("Line break before each generic requirement")
          }
          .help(
            "Determines the line-breaking behavior for generic requirements when the requirements list is wrapped onto multiple lines. If true, a line break will be added before each requirement, forcing the entire requirements list to be laid out vertically. If false, requirements will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
          )
          Toggle(isOn: viewStore.binding(\.$lineBreakAroundMultilineExpressionChainComponents)) {
            Text("Line break around multiline expression chain components")
          }
          .help(
            "Determines whether line breaks should be forced before and after multiline components of dot-chained expressions, such as function calls and subscripts chained together through member access (i.e. \".\" expressions). When any component is multiline and this option is true, a line break is forced before the \".\" of the component and after the component's closing delimiter (i.e. right paren, right bracket, right brace, etc.)."
          )
          Toggle(isOn: viewStore.binding(\.$prioritizeKeepingFunctionOutputTogether)) {
            Text("Prioritize keeping function output together")
          }
          .help(
            "Determines if function-like declaration outputs should be prioritized to be together with the function signature right (closing) parenthesis. If false, function output (i.e. throws, return type) is not prioritized to be together with the signature's right parenthesis, and when the line length would be exceeded, a line break will be fired after the function signature first, indenting the declaration output one additional level. If true, A line break will be fired further up in the function's declaration (e.g. generic parameters, parameters) before breaking on the function's output."
          )
          Toggle(isOn: viewStore.binding(\.$shouldTrimTrailingWhitespace)) {
            Text("Trim trailing whitespace before formatting")
          }
          .help(
            "The formatter trims trailing whitespace before formatting, so whitespace only lines won't get joined with the subsequent line."
          )
          HStack(spacing: 0) {
            Text("Maximum blank lines")
            Stepper(
              value: viewStore.binding(\.$maximumBlankLines),
              in: 0...1000,
              step: 1,
              label: {
                TextField(
                  "",
                  value: viewStore.binding(\.$maximumBlankLines),
                  formatter: uIntNumberFormatter
                )
                .modifier(PrimaryTextFieldStyle())
              }
            )
            .help(
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
        Text("File Scoped Declaration Privacy:").modifier(TrailingAlignmentStyle())
          .modifier(CenterAlignmentStyle())
        Picker("", selection: viewStore.binding(\.$fileScopedDeclarationPrivacy.accessLevel)) {
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.private.rawValue)
            .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.private)
          Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.fileprivate.rawValue)
            .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.fileprivate)
        }
        .help(
          "Determines the formal access level (i.e., the level specified in source code) for file-scoped declarations whose effective access level is private to the containing file."
        )
        .modifier(PrimaryPickerStyle())
      }
    }
  }

  @FocusState var shouldFocusFirstTextField: Bool
  public var body: some View {
    VStack(alignment: .trailingAlignmentGuide, spacing: .grid(4)) {
      indentationView
      tabWidthView
      lineLenghtView
      lineBreaksView
      fileScopedDeclarationPrivacyView
    }
    .modifier(PrimaryVStackStyle()).focused($shouldFocusFirstTextField)
    .onAppear { Task { shouldFocusFirstTextField = false } }
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

// MARK: FileScopedDeclarationPrivacy

extension FileScopedDeclarationPrivacyConfiguration.AccessLevel {
  public typealias RawValue = String

  public init?(rawValue: RawValue) { return nil }

  public var rawValue: RawValue {
    switch self {
    case .private: return "Private"
    case .fileprivate: return "Fileprivate"
    }
  }
}

// workaround for NumberFormatter bug: https://stackoverflow.com/questions/56799456/swiftui-textfield-with-formatter-not-working
extension TextField {
  public init(_ prompt: LocalizedStringKey, value: Binding<Int>, formatter: NumberFormatter)
  where Text == Label {
    self.init(
      prompt,
      text: .init(
        get: { formatter.string(for: value.wrappedValue) ?? String() },
        set: { value.wrappedValue = formatter.number(from: $0)?.intValue ?? value.wrappedValue }
      )
    )
  }
}

public class UIntNumberFormatter: NumberFormatter {
  public override init() {
    super.init()

    self.allowsFloats = false
    self.minimum = 0
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

let uIntNumberFormatter = UIntNumberFormatter()
