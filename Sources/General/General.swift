import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

public struct GeneralViewState: Equatable {
  public var useAutodiscovery: Bool

  public init(useAutodiscovery: Bool) { self.useAutodiscovery = useAutodiscovery }
}

public enum GeneralViewAction: Equatable { case useAutodiscoveryFilledOut(Bool) }

public let generalViewReducer = Reducer<GeneralViewState, GeneralViewAction, Void> {
  state,
  action,
  _ in
  switch action {
  case .useAutodiscoveryFilledOut(let value):
    state.useAutodiscovery = value
    return .fireAndForget { setUseAutodiscovery(newValue: value) }
  }
}

public struct GeneralView: View {
  let store: Store<GeneralViewState, GeneralViewAction>

  public init(store: Store<GeneralViewState, GeneralViewAction>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leadingAlignmentGuide, spacing: .grid(2)) {
        Toggle(
          isOn: Binding(
            get: { viewStore.useAutodiscovery },
            set: { viewStore.send(.useAutodiscoveryFilledOut($0)) }
          )
        ) { Text("Use configuration autodiscovery").modifier(LeadingAlignmentStyle()) }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        .help(
          "For any source file being checked or formatted, swift-format looks for a JSON-formatted file named .swift-format in the same directory. If one is found, then that file is loaded to determine the tool's configuration. If the file is not found, then it looks in the parent directory, and so on."
        )
        Text("Use .swift-format configuration files based on source file location")
          .modifier(SecondaryTextStyle())
      }
      .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
  }
}

func setUseAutodiscovery(newValue: Bool) {
  UserDefaults(suiteName: "group.com.kuglee.SwiftFormatter")!
    .set(newValue, forKey: AppConstants.useAutodiscovery)
}
