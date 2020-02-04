import ComposableArchitecture
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import Utility

public enum SettingsViewAction: Equatable {
  case maximumBlankLinesFilledOut(Int)
  case maximumBlankLinesIncremented
  case maximumBlankLinesDecremented
  case lineLengthFilledOut(Int)
  case lineLengthIncremented
  case lineLengthDecremented
  case tabWidthFilledOut(Int)
  case tabWidthIncremented
  case tabWidthDecremented
  case indentationSelected(Indent)
  case indentationCountFilledOut(Int)
  case indentationIncremented
  case indentationDecremented
  case respectsExistingLineBreaksFilledOut(Bool)
  case lineBreakBeforeControlFlowKeywordsFilledOut(Bool)
  case lineBreakBeforeEachArgumentFilledOut(Bool)
  case lineBreakBeforeEachGenericRequirementFilledOut(Bool)
  case prioritizeKeepingFunctionOutputTogetherFilledOut(Bool)
  case indentConditionalCompilationBlocksFilledOut(Bool)
  case lineBreakAroundMultilineExpressionChainComponentsFilledOut(Bool)
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
    lineBreakAroundMultilineExpressionChainComponents: Bool
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
  }
}

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

public func settingsViewReducer(
  state: inout SettingsViewState,
  action: SettingsViewAction
) -> [Effect<SettingsViewAction>] {
  switch action {
  case .maximumBlankLinesFilledOut(let value): state.maximumBlankLines = value
  case .maximumBlankLinesIncremented: state.maximumBlankLines += 1
  case .maximumBlankLinesDecremented: state.maximumBlankLines -= 1
  case .lineLengthFilledOut(let value): state.lineLength = value
  case .lineLengthIncremented: state.lineLength += 1
  case .lineLengthDecremented: state.lineLength -= 1
  case .tabWidthFilledOut(let value): state.tabWidth = value
  case .tabWidthIncremented: state.tabWidth += 1
  case .tabWidthDecremented: state.tabWidth -= 1
  case .indentationSelected(let value): state.indentation = value
  case .indentationCountFilledOut(let value): state.indentation.count = value
  case .indentationIncremented: state.indentation.count += 1
  case .indentationDecremented: state.indentation.count -= 1
  case .respectsExistingLineBreaksFilledOut(let value):
    state.respectsExistingLineBreaks = value
  case .lineBreakBeforeControlFlowKeywordsFilledOut(let value):
    state.lineBreakBeforeControlFlowKeywords = value
  case .lineBreakBeforeEachArgumentFilledOut(let value):
    state.lineBreakBeforeEachArgument = value
  case .indentConditionalCompilationBlocksFilledOut(let value):
    state.indentConditionalCompilationBlocks = value
  case .lineBreakBeforeEachGenericRequirementFilledOut(let value):
    state.lineBreakBeforeEachGenericRequirement = value
  case .prioritizeKeepingFunctionOutputTogetherFilledOut(let value):
    state.prioritizeKeepingFunctionOutputTogether = value
  case .lineBreakAroundMultilineExpressionChainComponentsFilledOut(let value):
    state.lineBreakAroundMultilineExpressionChainComponents = value
  }

  return []
}

public struct SettingsView: View {
  internal struct InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  @ObservedObject var store: Store<SettingsViewState, SettingsViewAction>

  public init(store: Store<SettingsViewState, SettingsViewAction>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .trailingAlignmentGuide, spacing: 9) {
      HStack(alignment: .centerAlignmentGuide) {
        Text("indentation:", bundle: InternalConstants.bundle)
          .modifier(TrailingAlignmentStyle()).modifier(CenterAlignmentStyle())
        VStack(alignment: .leading, spacing: 6) {
          HStack() {
            Text("length:", bundle: InternalConstants.bundle)
              .modifier(CenterAlignmentStyle())
            HStack(spacing: 0) {
              Stepper(
                onIncrement: { self.store.send(.indentationIncremented) },
                onDecrement: { self.store.send(.indentationDecremented) },
                label: {
                  TextField(
                    "",
                    value: Binding(
                      get: { self.store.value.indentation.count },
                      set: { self.store.send(.indentationCountFilledOut($0)) }
                    ),
                    formatter: UIntNumberFormatter()
                  )
                  .modifier(PrimaryTextFieldStyle())
                }
              )
              .toolTip("LENGTH_TOOLTIP", bundle: InternalConstants.bundle)
              Picker(
                "",
                selection: Binding(
                  get: { self.store.value.indentation },
                  set: { self.store.send(.indentationSelected($0)) }
                )
              ) {
                Text(
                  LocalizedStringKey(Indent.spaces(Int()).rawValue),
                  bundle: InternalConstants.bundle
                )
                .tag(Indent.spaces(self.store.value.indentation.count))
                Text(
                  LocalizedStringKey(Indent.tabs(Int()).rawValue),
                  bundle: InternalConstants.bundle
                )
                .tag(Indent.tabs(self.store.value.indentation.count))
              }
              .toolTip("WHITESPACE_TOOLTIP", bundle: InternalConstants.bundle)
              .modifier(PrimaryPickerStyle())
            }
          }
          Toggle(
            isOn: Binding(
              get: { self.store.value.indentConditionalCompilationBlocks },
              set: {
                self.store.send(
                  .indentConditionalCompilationBlocksFilledOut($0)
                )
              }
            )
          ) {
            Text(
              "indentConditionalCompilationBlocks",
              bundle: InternalConstants.bundle
            )
          }
          .toolTip(
            "INDENT_CONDITIONAL_COMPILATION_BLOCKS_TOOLTIP",
            bundle: InternalConstants.bundle
          )
        }
      }
      HStack {
        Text("tabWidth:", bundle: InternalConstants.bundle)
          .modifier(TrailingAlignmentStyle())
        Stepper(
          onIncrement: { self.store.send(.tabWidthIncremented) },
          onDecrement: { self.store.send(.tabWidthDecremented) },
          label: {
            TextField(
              "",
              value: Binding(
                get: { self.store.value.tabWidth },
                set: { self.store.send(.tabWidthFilledOut($0)) }
              ),
              formatter: UIntNumberFormatter()
            )
            .modifier(PrimaryTextFieldStyle())
          }
        )
        .toolTip("TAB_WIDTH_TOOLTIP", bundle: InternalConstants.bundle)
        Text("spaces", bundle: InternalConstants.bundle)
      }
      HStack {
        Text("lineLength:", bundle: InternalConstants.bundle)
          .modifier(TrailingAlignmentStyle())
        Stepper(
          onIncrement: { self.store.send(.lineLengthIncremented) },
          onDecrement: { self.store.send(.lineLengthDecremented) },
          label: {
            TextField(
              "",
              value: Binding(
                get: { self.store.value.lineLength },
                set: { self.store.send(.lineLengthFilledOut($0)) }
              ),
              formatter: UIntNumberFormatter()
            )
            .modifier(PrimaryTextFieldStyle())
          }
        )
        .toolTip("LINE_LENGTH_TOOLTIP", bundle: InternalConstants.bundle)
      }
      HStack(alignment: .firstTextBaseline) {
        Text("lineBreaks:", bundle: InternalConstants.bundle)
          .modifier(TrailingAlignmentStyle())
        VStack(alignment: .leading, spacing: 6) {
          Toggle(
            isOn: Binding(
              get: { self.store.value.respectsExistingLineBreaks },
              set: { self.store.send(.respectsExistingLineBreaksFilledOut($0)) }
            )
          ) {
            Text("respectsExistingLineBreaks", bundle: InternalConstants.bundle)
          }
          .toolTip(
            "RESPECTS_EXISTING_LINE_BREAKS",
            bundle: InternalConstants.bundle
          )
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeControlFlowKeywords },
              set: {
                self.store.send(
                  .lineBreakBeforeControlFlowKeywordsFilledOut($0)
                )
              }
            )
          ) {
            Text(
              "lineBreakBeforeControlFlowKeywords",
              bundle: InternalConstants.bundle
            )
          }
          .toolTip(
            "LINE_BREAK_BEFORE_CONTROL_FLOW_KEYWORDS_TOOLTIP",
            bundle: InternalConstants.bundle
          )
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeEachArgument },
              set: {
                self.store.send(.lineBreakBeforeEachArgumentFilledOut($0))
              }
            )
          ) {
            Text(
              "lineBreakBeforeEachArgument",
              bundle: InternalConstants.bundle
            )
          }
          .toolTip(
            "LINE_BREAK_BEFORE_EACH_ARGUMENT_TOOLTIP",
            bundle: InternalConstants.bundle
          )
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeEachGenericRequirement },
              set: {
                self.store.send(
                  .lineBreakBeforeEachGenericRequirementFilledOut($0)
                )
              }
            )
          ) {
            Text(
              "lineBreakBeforeEachGenericRequirement",
              bundle: InternalConstants.bundle
            )
          }
          .toolTip(
            "LINE_BREAK_BEFORE_EACH_GENERIC_REQUIREMENT_TOOLTIP",
            bundle: InternalConstants.bundle
          )
          Toggle(
            isOn: Binding(
              get: {
                self.store.value
                  .lineBreakAroundMultilineExpressionChainComponents
              },
              set: {
                self.store.send(
                  .lineBreakAroundMultilineExpressionChainComponentsFilledOut(
                    $0
                  )
                )
              }
            )
          ) {
            Text(
              "lineBreakAroundMultilineExpressionChainComponents",
              bundle: InternalConstants.bundle
            )
          }
          .toolTip(
            "LINE_BREAK_AROUND_MULTILINE_EXPRESSION_CHAIN_COMPONENTS_TOOLTIP",
            bundle: InternalConstants.bundle
          )
          Toggle(
            isOn: Binding(
              get: { self.store.value.prioritizeKeepingFunctionOutputTogether },
              set: {
                self.store.send(
                  .prioritizeKeepingFunctionOutputTogetherFilledOut($0)
                )
              }
            )
          ) {
            Text(
              "prioritizeKeepingFunctionOutputTogether",
              bundle: InternalConstants.bundle
            )
          }
          .toolTip(
            "PRIORITIZE_KEEPING_FUNCTION_OUTPUT_TOGETHER_TOOLTIP",
            bundle: InternalConstants.bundle
          )
          HStack {
            Text("maximumBlankLines:", bundle: InternalConstants.bundle)
            Stepper(
              onIncrement: { self.store.send(.maximumBlankLinesIncremented) },
              onDecrement: { self.store.send(.maximumBlankLinesDecremented) },
              label: {
                TextField(
                  "",
                  value: Binding(
                    get: { self.store.value.maximumBlankLines },
                    set: { self.store.send(.maximumBlankLinesFilledOut($0)) }
                  ),
                  formatter: UIntNumberFormatter()
                )
                .modifier(PrimaryTextFieldStyle())
              }
            )
            .toolTip(
              "MAXIMUM_BLANK_LINES_TOOLTIP",
              bundle: InternalConstants.bundle
            )
          }
        }
      }
    }
    .modifier(PrimaryVStackStyle())
  }
}
