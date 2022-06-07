import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

public enum LineLengthViewAction: Equatable {
  case lineLengthFilledOut(Int)
  case lineLengthIncremented
  case lineLengthDecremented
}

public struct LineLengthViewState {
  public var lineLength: Int

  public init(lineLength: Int) { self.lineLength = lineLength }
}

public func lineLengthViewReducer(
  state: inout LineLengthViewState,
  action: LineLengthViewAction
) -> [Effect<LineLengthViewAction>] {
  switch action {
  case .lineLengthFilledOut(let value): state.lineLength = value
  case .lineLengthIncremented: state.lineLength += 1
  case .lineLengthDecremented: state.lineLength -= 1
  }

  return []
}

public struct LineLengthView: View {
  @ObservedObject var store: Store<LineLengthViewState, LineLengthViewAction>

  public init(store: Store<LineLengthViewState, LineLengthViewAction>) {
    self.store = store
  }

  public var body: some View {
    HStack {
      Text("Line Length:")
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
      .toolTip("The maximum allowed length of a line, in characters")
    }
  }
}
