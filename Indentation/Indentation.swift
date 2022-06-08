import ComposableArchitecture
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import Utility

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
}

public struct IndentationViewState {
  public var indentation: Indent
  public var indentConditionalCompilationBlocks: Bool

  public init(indentation: Indent, indentConditionalCompilationBlocks: Bool) {
    self.indentation = indentation
    self.indentConditionalCompilationBlocks = indentConditionalCompilationBlocks
  }
}

public func indentationViewReducer(
  state: inout IndentationViewState,
  action: IndentationViewAction
) -> [Effect<IndentationViewAction>] {
  switch action {
  case .indentationSelected(let value): state.indentation = value
  case .indentationCountFilledOut(let value): state.indentation.count = value
  case .indentationIncremented: state.indentation.count += 1
  case .indentationDecremented: state.indentation.count -= 1
  case .indentConditionalCompilationBlocksFilledOut(let value):
    state.indentConditionalCompilationBlocks = value
  }

  return []
}

public struct IndentationView: View {
  @ObservedObject var store: Store<IndentationViewState, IndentationViewAction>

  public init(store: Store<IndentationViewState, IndentationViewAction>) {
    self.store = store
  }

  public var body: some View {
    HStack(alignment: .centerAlignmentGuide) {
      Text("Indentation:")
        .modifier(TrailingAlignmentStyle()).modifier(CenterAlignmentStyle())
      VStack(alignment: .leading, spacing: .grid(2)) {
        HStack {
          Text("Length:")
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
            .toolTip("The amount of whitespace that should be added when indenting one level")
            Picker(
              "",
              selection: Binding(
                get: { self.store.value.indentation },
                set: { self.store.send(.indentationSelected($0)) }
              )
            ) {
              Text(Indent.spaces(Int()).rawValue)
                .tag(Indent.spaces(self.store.value.indentation.count))
              Text(Indent.tabs(Int()).rawValue)
                .tag(Indent.tabs(self.store.value.indentation.count))
            }
            .toolTip("The type of whitespace that should be added when indenting")
            .modifier(PrimaryPickerStyle())
          }
        }
        Toggle(
          isOn: Binding(
            get: { self.store.value.indentConditionalCompilationBlocks },
            set: {
              self.store.send(.indentConditionalCompilationBlocksFilledOut($0))
            }
          )
        ) {
          Text("Indent conditional compilation blocks")
        }
        .toolTip(
          "Determines if conditional compilation blocks are indented. If this setting is false the body of #if, #elseif, and #else is not indented."
        )
      }
    }
  }
}
