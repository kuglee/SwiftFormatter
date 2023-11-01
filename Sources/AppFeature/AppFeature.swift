import AppUserDefaults
import ComposableArchitecture
import ConfigurationWrapper
import SettingsFeature
import SwiftUI
import WelcomeFeature

public struct AppFeature: Reducer {
  @Dependency(\.appUserDefaults) var appUserDefaults

  public init() {}

  public struct State: Equatable {
    public var settingsFeatureState: SettingsFeature.State
    var didRunBefore: Bool

    public init(
      settingsFeatureState: SettingsFeature.State = SettingsFeature.State(
        configuration: AppUserDefaults.live.getConfigurationWrapper(),
        shouldTrimTrailingWhitespace: AppUserDefaults.live.getShouldTrimTrailingWhitespace()
      ),
      didRunBefore: Bool = AppUserDefaults.live.getDidRunBefore()
    ) {
      self.settingsFeatureState = settingsFeatureState
      self.didRunBefore = didRunBefore
    }
  }

  public enum Action {
    case dismissWelcomeSheet
    case settingsFeature(action: SettingsFeature.Action)
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissWelcomeSheet:
        state.didRunBefore = true
        return .none
      case .settingsFeature(_): return .none
      }
    }
    .onChange(of: \.didRunBefore) { _, newValue in
      Reduce { state, action in
        self.appUserDefaults.setDidRunBefore(newValue)

        return .none
      }
    }
    Scope(state: \.settingsFeatureState, action: /Action.settingsFeature(action:)) {
      SettingsFeature()
    }
    .onChange(of: \.settingsFeatureState.configuration) { _, newValue in
      Reduce { state, action in
        self.appUserDefaults.setConfigurationWrapper(newValue)

        return .none
      }
    }
    .onChange(of: \.settingsFeatureState.shouldTrimTrailingWhitespace) { _, newValue in
      Reduce { state, action in
        self.appUserDefaults.setShouldTrimTrailingWhitespace(newValue)

        return .none
      }
    }
  }
}

public struct AppFeatureView: View {
  let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store, observe: { !$0.didRunBefore }) { viewStore in
      SettingsFeatureView(
        store: store.scope(state: \.settingsFeatureState, action: AppFeature.Action.settingsFeature)
      )
      .sheet(isPresented: viewStore.binding(send: .dismissWelcomeSheet)) {
        WelcomeFeatureView()
          .background(VisualEffect(material: .windowBackground, blendingMode: .withinWindow))
      }
    }
  }
}
