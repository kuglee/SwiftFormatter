import AppUserDefaults
import ComposableArchitecture
import ConfigurationWrapper
import SettingsFeature
import SwiftUI
import WelcomeFeature

public struct AppFeature: ReducerProtocol {
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
    case welcomeFeature(action: WelcomeFeature.Action)
    case settingsFeature(action: SettingsFeature.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .welcomeFeature(_): return .none
      case .settingsFeature(_): return .none
      }
    }

    Scope(state: \.welcomeFeature, action: /Action.welcomeFeature(action:)) { WelcomeFeature() }
      .onChange(of: \.didRunBefore) { didRunBefore, _, _ in
        self.appUserDefaults.setDidRunBefore(didRunBefore)
        return .none
      }

    Scope(state: \.settingsFeature, action: /Action.settingsFeature(action:)) { SettingsFeature() }
      .onChange(of: \.configuration) { configuration, _, _ in
        self.appUserDefaults.setConfigurationWrapper(configuration)
        return .none
      }
      .onChange(of: \.shouldTrimTrailingWhitespace) { shouldTrimTrailingWhitespace, _, _ in
        self.appUserDefaults.setShouldTrimTrailingWhitespace(shouldTrimTrailingWhitespace)
        return .none
      }
  }
}

extension AppFeature.State {
  var welcomeFeature: WelcomeFeature.State {
    get { return WelcomeFeature.State(isDismissed: self.didRunBefore) }
    set { self.didRunBefore = newValue.isDismissed }
  }

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
    WithViewStore(self.store) { viewStore in
      SettingsFeatureView(
        store: store.scope(state: \.settingsFeature, action: AppFeature.Action.settingsFeature)
      )
      .sheet(isPresented: Binding.constant(!viewStore.didRunBefore)) {
        WelcomeFeatureView(
          store: self.store.scope(state: \.welcomeFeature, action: AppFeature.Action.welcomeFeature)
        )
      }
    }
  }
}

// from Isowords: https://github.com/pointfreeco/isowords/blob/9661c88cbf8e6d0bc41b6069f38ff6df29b9c2c4/Sources/TcaHelpers/OnChange.swift
extension ReducerProtocol {
  @inlinable public func onChange<ChildState: Equatable>(
    of toLocalState: @escaping (State) -> ChildState,
    perform additionalEffects: @escaping (ChildState, inout State, Action) -> Effect<Action, Never>
  ) -> some ReducerProtocol<State, Action> {
    self.onChange(of: toLocalState) { additionalEffects($1, &$2, $3) }
  }

  @inlinable public func onChange<ChildState: Equatable>(
    of toLocalState: @escaping (State) -> ChildState,
    perform additionalEffects: @escaping (ChildState, ChildState, inout State, Action) -> Effect<
      Action, Never
    >
  ) -> some ReducerProtocol<State, Action> {
    ChangeReducer(base: self, toLocalState: toLocalState, perform: additionalEffects)
  }
}

@usableFromInline
struct ChangeReducer<Base: ReducerProtocol, ChildState: Equatable>: ReducerProtocol {
  @usableFromInline let base: Base

  @usableFromInline let toLocalState: (Base.State) -> ChildState

  @usableFromInline let perform:
    (ChildState, ChildState, inout Base.State, Base.Action) -> Effect<Base.Action, Never>

  @usableFromInline init(
    base: Base,
    toLocalState: @escaping (Base.State) -> ChildState,
    perform: @escaping (ChildState, ChildState, inout Base.State, Base.Action) -> Effect<
      Base.Action, Never
    >
  ) {
    self.base = base
    self.toLocalState = toLocalState
    self.perform = perform
  }

  @inlinable public func reduce(into state: inout Base.State, action: Base.Action) -> Effect<
    Base.Action, Never
  > {
    let previousLocalState = self.toLocalState(state)
    let effects = self.base.reduce(into: &state, action: action)
    let localState = self.toLocalState(state)

    return previousLocalState != localState
      ? .merge(effects, self.perform(previousLocalState, localState, &state, action)) : effects
  }
}
