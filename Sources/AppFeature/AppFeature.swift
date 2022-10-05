import AppUserDefaults
import ComposableArchitecture
import SettingsFeature
import SwiftFormatConfiguration
import SwiftUI

public struct AppFeature: ReducerProtocol {
  @Dependency(\.appUserDefaults) var appUserDefaults

  public init() {}

  public struct State: Equatable {
    public var configuration: Configuration
    public var selectedTab: Tab = .formatting
    public var didRunBefore: Bool
    public var shouldTrimTrailingWhitespace: Bool

    public init(
      configuration: Configuration,
      didRunBefore: Bool,
      shouldTrimTrailingWhitespace: Bool
    ) {
      self.didRunBefore = didRunBefore
      self.shouldTrimTrailingWhitespace = shouldTrimTrailingWhitespace
      self.configuration = configuration
    }
  }

  public enum Action {
    case setDidRunBefore
    case settingsFeature(action: SettingsFeature.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .setDidRunBefore:
        state.didRunBefore = true
        return .none
      case .settingsFeature(_): return .none
      }
    }
    Scope(state: \.settingsFeature, action: /Action.settingsFeature(action:)) { SettingsFeature() }
      .onChange(of: \.configuration) { configuration, _, _ in
        self.appUserDefaults.setConfiguration(configuration)
        return .none
      }
      .onChange(of: \.shouldTrimTrailingWhitespace) { shouldTrimTrailingWhitespace, _, _ in
        self.appUserDefaults.setShouldTrimTrailingWhitespace(shouldTrimTrailingWhitespace)
        return .none
      }
      .onChange(of: \.didRunBefore) { didRunBefore, _, _ in
        self.appUserDefaults.setDidRunBefore(didRunBefore)
        return .none
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

func appViewBody(store: StoreOf<AppFeature>) -> some View {
  SettingsFeatureView(
    store: store.scope(state: \.settingsFeature, action: AppFeature.Action.settingsFeature)
  )
}

@available(macOS 13.0, *) public struct AppViewMacOS13: View {
  let store: StoreOf<AppFeature>
  @Environment(\.openWindow) private var openWindow

  public init(store: StoreOf<AppFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      appViewBody(store: self.store)
        .task {
          if !viewStore.didRunBefore {
            viewStore.send(.setDidRunBefore)
            try? await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
            openWindow(id: "welcome")
          }
        }
    }
  }
}

public struct AppViewMacOS12: View {
  let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in appViewBody(store: store) }
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
