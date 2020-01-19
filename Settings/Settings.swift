import ComposableArchitecture
import SwiftFormatConfiguration
import SwiftUI

class UIntNumberFormatter: NumberFormatter {
  override init() {
    super.init()

    self.allowsFloats = false
    self.minimum = 0
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

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
  case ignoreSingleLinePropertiesFilledOut(Bool)
}

public struct SettingsViewState {
  public var maximumBlankLines: Int
  public var lineLength: Int
  public var tabWidth: Int
  public var indentation: Indent
  public var respectsExistingLineBreaks: Bool
  public var blankLineBetweenMembers: BlankLineBetweenMembersConfiguration
  public var lineBreakBeforeControlFlowKeywords: Bool
  public var lineBreakBeforeEachArgument: Bool
  public var lineBreakBeforeEachGenericRequirement: Bool
  public var prioritizeKeepingFunctionOutputTogether: Bool
  public var indentConditionalCompilationBlocks: Bool

  public init(
    maximumBlankLines: Int,
    lineLength: Int,
    tabWidth: Int,
    indentation: Indent,
    respectsExistingLineBreaks: Bool,
    blankLineBetweenMembers: BlankLineBetweenMembersConfiguration,
    lineBreakBeforeControlFlowKeywords: Bool,
    lineBreakBeforeEachArgument: Bool,
    lineBreakBeforeEachGenericRequirement: Bool,
    prioritizeKeepingFunctionOutputTogether: Bool,
    indentConditionalCompilationBlocks: Bool
  ) {
    self.maximumBlankLines = maximumBlankLines
    self.lineLength = lineLength
    self.tabWidth = tabWidth
    self.indentation = indentation
    self.respectsExistingLineBreaks = respectsExistingLineBreaks
    self.blankLineBetweenMembers = blankLineBetweenMembers
    self.lineBreakBeforeControlFlowKeywords = lineBreakBeforeControlFlowKeywords
    self.lineBreakBeforeEachArgument = lineBreakBeforeEachArgument
    self.lineBreakBeforeEachGenericRequirement =
      lineBreakBeforeEachGenericRequirement
    self.prioritizeKeepingFunctionOutputTogether =
      prioritizeKeepingFunctionOutputTogether
    self.indentConditionalCompilationBlocks = indentConditionalCompilationBlocks
  }
}

extension Indent: RawRepresentable {
  public typealias RawValue = String

  public init?(rawValue: RawValue) { return nil }

  public var rawValue: RawValue {
    switch self {
    case .spaces: return "spaces"
    case .tabs: return "tabs"
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
  case .ignoreSingleLinePropertiesFilledOut(let value):
    state.blankLineBetweenMembers = BlankLineBetweenMembersConfiguration(
      ignoreSingleLineProperties: value
    )
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
  }

  return []
}

public struct SettingsView: View {
  @ObservedObject var store: Store<SettingsViewState, SettingsViewAction>

  public init(store: Store<SettingsViewState, SettingsViewAction>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .trailingAlignmentGuide, spacing: 9) {
      HStack(alignment: .topAlignmentGuide) {
        Text("indentation:").modifier(TrailingAlignmentStyle()).modifier(
          TopAlignmentStyle()
        )
        VStack(alignment: .leading, spacing: 6) {
          Picker(
            selection: Binding(
              get: { self.store.value.indentation },
              set: { self.store.send(.indentationSelected($0)) }
            ),
            label: Text("type:").modifier(TopAlignmentStyle())
          ) {
            Text(Indent.spaces(Int()).rawValue).tag(
              Indent.spaces(self.store.value.indentation.count)
            )
            Text(Indent.tabs(Int()).rawValue).tag(
              Indent.tabs(self.store.value.indentation.count)
            )
          }.frame(maxWidth: 120)
          HStack {
            Text("length:")
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
                ).modifier(PrimaryTextFieldStyle())
              }
            )
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
          ) { Text("indentConditionalCompilationBlocks") }
        }
      }
      HStack {
        Text("tab width:").modifier(TrailingAlignmentStyle())
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
            ).modifier(PrimaryTextFieldStyle())
          }
        )
      }
      HStack {
        Text("line length:").modifier(TrailingAlignmentStyle())
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
            ).modifier(PrimaryTextFieldStyle())
          }
        )
      }
      HStack(alignment: .firstTextBaseline) {
        Text("line breaks:").modifier(TrailingAlignmentStyle())
        VStack(alignment: .leading, spacing: 6) {
          Toggle(
            isOn: Binding(
              get: { self.store.value.respectsExistingLineBreaks },
              set: { self.store.send(.respectsExistingLineBreaksFilledOut($0)) }
            )
          ) { Text("respectsExistingLineBreaks") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeControlFlowKeywords },
              set: {
                self.store.send(
                  .lineBreakBeforeControlFlowKeywordsFilledOut($0)
                )
              }
            )
          ) { Text("lineBreakBeforeControlFlowKeywords") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeEachArgument },
              set: {
                self.store.send(.lineBreakBeforeEachArgumentFilledOut($0))
              }
            )
          ) { Text("lineBreakBeforeEachArgument") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeEachGenericRequirement },
              set: {
                self.store.send(
                  .lineBreakBeforeEachGenericRequirementFilledOut($0)
                )
              }
            )
          ) { Text("lineBreakBeforeEachGenericRequirement") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.prioritizeKeepingFunctionOutputTogether },
              set: {
                self.store.send(
                  .prioritizeKeepingFunctionOutputTogetherFilledOut($0)
                )
              }
            )
          ) { Text("prioritizeKeepingFunctionOutputTogether") }
          HStack {
            Text("maximumBlankLines:")
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
                ).modifier(PrimaryTextFieldStyle())
              }
            )
          }
        }
      }
      HStack(alignment: .top) {
        Text("blankLineBetweenMembers:").modifier(TrailingAlignmentStyle())
        VStack(alignment: .leading, spacing: 6) {
          Toggle(
            isOn: Binding(
              get: {
                self.store.value.blankLineBetweenMembers
                  .ignoreSingleLineProperties
              },
              set: { self.store.send(.ignoreSingleLinePropertiesFilledOut($0)) }
            )
          ) { Text("ignoreSingleLineProperties") }
        }
      }
    }.frame(
      minWidth: 0,
      maxWidth: .infinity,
      minHeight: 0,
      maxHeight: .infinity,
      alignment: .top
    )
  }
}

extension HorizontalAlignment {
  private enum TrailingAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[.leading]
    }
  }

  static let trailingAlignmentGuide = HorizontalAlignment(
    TrailingAlignment.self
  )
}

struct PrimaryTextFieldStyle: ViewModifier {
  func body(content: Content) -> some View {
    content.multilineTextAlignment(.trailing).frame(width: 40)
  }
}

struct TrailingAlignmentStyle: ViewModifier {
  func body(content: Content) -> some View {
    content.alignmentGuide(.trailingAlignmentGuide) { $0[.trailing] }
  }
}

extension VerticalAlignment {
  private enum TopAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[.top]
    }
  }

  static let topAlignmentGuide = VerticalAlignment(TopAlignment.self)
}

struct TopAlignmentStyle: ViewModifier {
  func body(content: Content) -> some View {
    content.alignmentGuide(.topAlignmentGuide) { $0[.top] }
  }
}
