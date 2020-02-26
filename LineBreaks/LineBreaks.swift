import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

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
    maximumBlankLines: Int,
    respectsExistingLineBreaks: Bool,
    lineBreakBeforeControlFlowKeywords: Bool,
    lineBreakBeforeEachArgument: Bool,
    lineBreakBeforeEachGenericRequirement: Bool,
    prioritizeKeepingFunctionOutputTogether: Bool,
    lineBreakAroundMultilineExpressionChainComponents: Bool
  ) {
    self.maximumBlankLines = maximumBlankLines
    self.respectsExistingLineBreaks = respectsExistingLineBreaks
    self.lineBreakBeforeControlFlowKeywords = lineBreakBeforeControlFlowKeywords
    self.lineBreakBeforeEachArgument = lineBreakBeforeEachArgument
    self.lineBreakBeforeEachGenericRequirement =
      lineBreakBeforeEachGenericRequirement
    self.prioritizeKeepingFunctionOutputTogether =
      prioritizeKeepingFunctionOutputTogether
    self.lineBreakAroundMultilineExpressionChainComponents =
      lineBreakAroundMultilineExpressionChainComponents
  }
}

public func lineBreaksViewReducer(
  state: inout LineBreaksViewState,
  action: LineBreaksViewAction
) -> [Effect<LineBreaksViewAction>] {
  switch action {
  case .maximumBlankLinesFilledOut(let value): state.maximumBlankLines = value
  case .maximumBlankLinesIncremented: state.maximumBlankLines += 1
  case .maximumBlankLinesDecremented: state.maximumBlankLines -= 1
  case .respectsExistingLineBreaksFilledOut(let value):
    state.respectsExistingLineBreaks = value
  case .lineBreakBeforeControlFlowKeywordsFilledOut(let value):
    state.lineBreakBeforeControlFlowKeywords = value
  case .lineBreakBeforeEachArgumentFilledOut(let value):
    state.lineBreakBeforeEachArgument = value
  case .lineBreakBeforeEachGenericRequirementFilledOut(let value):
    state.lineBreakBeforeEachGenericRequirement = value
  case .prioritizeKeepingFunctionOutputTogetherFilledOut(let value):
    state.prioritizeKeepingFunctionOutputTogether = value
  case .lineBreakAroundMultilineExpressionChainComponentsFilledOut(let value):
    state.lineBreakAroundMultilineExpressionChainComponents = value
  }

  return []
}

public struct LineBreaksView: View {
  internal enum InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  @ObservedObject var store: Store<LineBreaksViewState, LineBreaksViewAction>

  public init(store: Store<LineBreaksViewState, LineBreaksViewAction>) {
    self.store = store
  }

  public var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Text("lineBreaks:", bundle: InternalConstants.bundle)
        .modifier(TrailingAlignmentStyle())
      VStack(alignment: .leading, spacing: .grid(2)) {
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
              self.store.send(.lineBreakBeforeControlFlowKeywordsFilledOut($0))
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
            set: { self.store.send(.lineBreakBeforeEachArgumentFilledOut($0)) }
          )
        ) {
          Text("lineBreakBeforeEachArgument", bundle: InternalConstants.bundle)
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
              self.store.value.lineBreakAroundMultilineExpressionChainComponents
            },
            set: {
              self.store.send(
                .lineBreakAroundMultilineExpressionChainComponentsFilledOut($0)
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
}
