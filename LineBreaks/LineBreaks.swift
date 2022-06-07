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
  @ObservedObject var store: Store<LineBreaksViewState, LineBreaksViewAction>

  public init(store: Store<LineBreaksViewState, LineBreaksViewAction>) {
    self.store = store
  }

  public var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Text("Line breaks:")
        .modifier(TrailingAlignmentStyle())
      VStack(alignment: .leading, spacing: .grid(2)) {
        Toggle(
          isOn: Binding(
            get: { self.store.value.respectsExistingLineBreaks },
            set: { self.store.send(.respectsExistingLineBreaksFilledOut($0)) }
          )
        ) {
          Text("Respects existing line breaks")
        }
        .toolTip(
          "Indicates whether or not existing line breaks in the source code should be honored (if they are valid according to the style guidelines being enforced). If this settings is false, then the formatter will be more opinionated by only inserting line breaks where absolutely necessary and removing any others, effectively canonicalizing the output."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.lineBreakBeforeControlFlowKeywords },
            set: {
              self.store.send(.lineBreakBeforeControlFlowKeywordsFilledOut($0))
            }
          )
        ) {
          Text( "Line break before control flow keywords")
        }
        .toolTip(
          "Determines the line-breaking behavior for control flow keywords that follow a closing brace, like else and catch. If true, a line break will be added before the keyword, forcing it onto its own line. If false, the keyword will be placed after the closing brace (separated by a space)."
        )
        Toggle(
          isOn: Binding(
            get: { self.store.value.lineBreakBeforeEachArgument },
            set: { self.store.send(.lineBreakBeforeEachArgumentFilledOut($0)) }
          )
        ) {
          Text("Line break before each argument")
        }
        .toolTip(
          "Determines the line-breaking behavior for generic arguments and function arguments when a declaration is wrapped onto multiple lines. If true, a line break will be added before each argument, forcing the entire argument list to be laid out vertically. If false, arguments will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
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
          Text("Line break before each generic requirement")
        }
        .toolTip(
          "Determines the line-breaking behavior for generic requirements when the requirements list is wrapped onto multiple lines. If true, a line break will be added before each requirement, forcing the entire requirements list to be laid out vertically. If false, requirements will be laid out horizontally first, with line breaks only being fired when the line length would be exceeded."
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
          Text("Line break around multiline expression chain components" )
        }
        .toolTip(
          "Determines whether line breaks should be forced before and after multiline components of dot-chained expressions, such as function calls and subscripts chained together through member access (i.e. \".\" expressions). When any component is multiline and this option is true, a line break is forced before the \".\" of the component and after the component's closing delimiter (i.e. right paren, right bracket, right brace, etc.)."
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
          Text("Prioritize keeping function output together")
        }
        .toolTip(
          "Determines if function-like declaration outputs should be prioritized to be together with the function signature right (closing) parenthesis. If false, function output (i.e. throws, return type) is not prioritized to be together with the signature's right parenthesis, and when the line length would be exceeded, a line break will be fired after the function signature first, indenting the declaration output one additional level. If true, A line break will be fired further up in the function's declaration (e.g. generic parameters, parameters) before breaking on the function's output."
        )
        HStack {
          Text("Maximum blank lines")
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
            "The maximum number of consecutive blank lines that are allowed to be present in a source file. Any number larger than this will be collapsed down to the maximum."
          )
        }
      }
    }
  }
}
