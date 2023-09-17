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
    var configuration: ConfigurationWrapper
    var selectedTab: Tab = .formatting
    var didRunBefore: Bool
    var shouldTrimTrailingWhitespace: Bool

    public init(
      configuration: ConfigurationWrapper = AppUserDefaults.live.getConfigurationWrapper(),
      didRunBefore: Bool = AppUserDefaults.live.getDidRunBefore(),
      shouldTrimTrailingWhitespace: Bool = AppUserDefaults.live.getShouldTrimTrailingWhitespace()
    ) {
      self.didRunBefore = didRunBefore
      self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
      self.configuration = configuration
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
      Reduce { state, action in .run { send in self.appUserDefaults.setDidRunBefore(newValue) } }
    }
    Scope(state: \.settingsFeature, action: /Action.settingsFeature(action:)) { SettingsFeature() }
      .onChange(of: \.configuration) { _, newValue in
        Reduce { state, action in
          .run { send in self.appUserDefaults.setConfigurationWrapper(newValue) }
        }
      }
      .onChange(of: \.shouldTrimTrailingWhitespace) { _, newValue in
        Reduce { state, action in
          .run { send in self.appUserDefaults.setShouldTrimTrailingWhitespace(newValue) }
        }
      }
  }
}

extension AppFeature.State {
  var settingsFeature: SettingsFeature.State {
    get {
      SettingsFeature.State(
        configuration: self.configuration,
        shouldTrimTrailingWhitespace: self.shouldTrimTrailingWhitespace,
        selectedTab: self.selectedTab
      )
    }
    set {
      self.configuration = newValue.configuration
      self.shouldTrimTrailingWhitespace = newValue.shouldTrimTrailingWhitespace
      self.selectedTab = newValue.selectedTab
    }
  }
}

public struct AppFeatureView: View {
  let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store, observe: { !$0.didRunBefore }) { viewStore in
      SettingsFeatureView(
        store: store.scope(state: \.settingsFeature, action: AppFeature.Action.settingsFeature)
      )
      .sheet(isPresented: viewStore.binding(send: .dismissWelcomeSheet)) {
        WelcomeFeatureView()
          .background(VisualEffect(material: .windowBackground, blendingMode: .withinWindow))
      }
    }
  }
}
