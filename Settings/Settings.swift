import ComposableArchitecture
import SwiftFormatConfiguration
import SwiftUI
import os.log

public enum SettingsViewAction: Equatable {
  case maximumBlankLinesFilledOut(value: String)
  case lineLengthFilledOut(value: String)
  case tabWidthFilledOut(value: String)
  case indentationSelected(value: Indent)
  case indentationCountFilledOut(value: String)
  case respectsExistingLineBreaksFilledOut(value: Bool)
  case lineBreakBeforeControlFlowKeywordsFilledOut(value: Bool)
  case lineBreakBeforeEachArgumentFilledOut(value: Bool)
  case lineBreakBeforeEachGenericRequirementFilledOut(value: Bool)
  case prioritizeKeepingFunctionOutputTogetherFilledOut(value: Bool)
  case indentConditionalCompilationBlocksFilledOut(value: Bool)
  case ignoreSingleLinePropertiesFilledOut(value: Bool)
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
}

public func settingsViewReducer(
  state: inout SettingsViewState,
  action: SettingsViewAction
) -> [Effect<SettingsViewAction>] {
  switch action {
  case .maximumBlankLinesFilledOut(let value):
    state.maximumBlankLines = Int(value) ?? 0
  case .lineLengthFilledOut(let value): state.lineLength = Int(value) ?? 0
  case .tabWidthFilledOut(let value): state.tabWidth = Int(value) ?? 0
  case .indentationSelected(let value): state.indentation = value
  case .indentationCountFilledOut(let value):
    switch state.indentation {
    case .spaces: state.indentation = Indent.spaces(Int(value) ?? 0)
    case .tabs: state.indentation = Indent.tabs(Int(value) ?? 0)
    }
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

extension HorizontalAlignment {
  private enum MyAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[.trailing]
    }
  }

  static let myAlignmentGuide = HorizontalAlignment(MyAlignment.self)
}

public struct SettingsView: View {
  @ObservedObject var store: Store<SettingsViewState, SettingsViewAction>
  public init(store: Store<SettingsViewState, SettingsViewAction>) {
    self.store = store
  }
  public var body: some View {
    VStack(alignment: .myAlignmentGuide, spacing: 9) {
      HStack(alignment: .top) {
        Text("indentation:").alignmentGuide(
          .myAlignmentGuide,
          computeValue: { d in d[.trailing] }
        ).offset(y: 3)
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            Text("type:")
            Picker(
              "",
              selection: Binding(
                get: { self.store.value.indentation },
                set: { self.store.send(.indentationSelected(value: $0)) }
              )
            ) {
              Text(Indent.spaces(Int()).rawValue).tag(
                Indent.spaces(self.store.value.indentation.count)
              )
              Text(Indent.tabs(Int()).rawValue).tag(
                Indent.tabs(self.store.value.indentation.count)
              )
            }.labelsHidden().frame(maxWidth: 100)
          }
          HStack {
            Text("length:")
            TextField(
              "",
              text: Binding(
                get: { "\(self.store.value.indentation.count)" },
                set: { self.store.send(.indentationCountFilledOut(value: $0)) }
              )
            ).frame(width: 40)
          }
          Toggle(
            isOn: Binding(
              get: { self.store.value.indentConditionalCompilationBlocks },
              set: {
                self.store.send(
                  .indentConditionalCompilationBlocksFilledOut(value: $0)
                )
              }
            )
          ) { Text("indentConditionalCompilationBlocks") }
        }
      }
      HStack {
        Text("tab width:").alignmentGuide(
          .myAlignmentGuide,
          computeValue: { d in d[.trailing] }
        )
        TextField(
          "",
          text: Binding(
            get: { "\(self.store.value.tabWidth)" },
            set: { self.store.send(.tabWidthFilledOut(value: $0)) }
          )
        ).frame(width: 40)
      }
      HStack {
        Text("line length:").alignmentGuide(
          .myAlignmentGuide,
          computeValue: { d in d[.trailing] }
        )
        TextField(
          "",
          text: Binding(
            get: { "\(self.store.value.lineLength)" },
            set: { self.store.send(.lineLengthFilledOut(value: $0)) }
          )
        ).frame(width: 40)
      }
      HStack(alignment: .firstTextBaseline) {
        Text("line breaks:").alignmentGuide(
          .myAlignmentGuide,
          computeValue: { d in d[.trailing] }
        )
        VStack(alignment: .leading, spacing: 6) {
          Toggle(
            isOn: Binding(
              get: { self.store.value.respectsExistingLineBreaks },
              set: {
                self.store.send(.respectsExistingLineBreaksFilledOut(value: $0))
              }
            )
          ) { Text("respectsExistingLineBreaks") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeControlFlowKeywords },
              set: {
                self.store.send(
                  .lineBreakBeforeControlFlowKeywordsFilledOut(value: $0)
                )
              }
            )
          ) { Text("lineBreakBeforeControlFlowKeywords") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeEachArgument },
              set: {
                self.store.send(
                  .lineBreakBeforeEachArgumentFilledOut(value: $0)
                )
              }
            )
          ) { Text("lineBreakBeforeEachArgument") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.lineBreakBeforeEachGenericRequirement },
              set: {
                self.store.send(
                  .lineBreakBeforeEachGenericRequirementFilledOut(value: $0)
                )
              }
            )
          ) { Text("lineBreakBeforeEachGenericRequirement") }
          Toggle(
            isOn: Binding(
              get: { self.store.value.prioritizeKeepingFunctionOutputTogether },
              set: {
                self.store.send(
                  .prioritizeKeepingFunctionOutputTogetherFilledOut(value: $0)
                )
              }
            )
          ) { Text("prioritizeKeepingFunctionOutputTogether") }
          HStack {
            Text("maximumBlankLines:")
            TextField(
              "",
              text: Binding(
                get: { "\(self.store.value.maximumBlankLines)" },
                set: { self.store.send(.maximumBlankLinesFilledOut(value: $0)) }
              )
            ).frame(width: 40)
          }
        }
      }
      HStack(alignment: .top) {
        Text("blankLineBetweenMembers:").alignmentGuide(
          .myAlignmentGuide,
          computeValue: { d in d[.trailing] }
        )
        VStack(alignment: .leading, spacing: 6) {
          Toggle(
            isOn: Binding(
              get: {
                self.store.value.blankLineBetweenMembers
                  .ignoreSingleLineProperties
              },
              set: {
                self.store.send(.ignoreSingleLinePropertiesFilledOut(value: $0))
              }
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

fileprivate let configFileURL: URL = FileManager.default.urls(
  for: .libraryDirectory,
  in: .userDomainMask
).first!.appendingPathComponent("Preferences/swift-format.json")

func loadConfiguration(fromFileAtPath path: URL?) -> Configuration {
  if let path = path {
    do {
      //      let url = URL(fileURLWithPath: path)
      let data = try Data(contentsOf: path)
      return try JSONDecoder().decode(Configuration.self, from: data)
    } catch {
      os_log(
        "Could not load configuration at %{public}@: %{public}@",
        path.absoluteString,
        error.localizedDescription
      )
    }
  }
  return Configuration()
}
