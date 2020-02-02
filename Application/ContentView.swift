import About
import ComposableArchitecture
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import TabbedView

public struct AppState {
  public var configuration: Configuration
  public var selectedTab: Int

  public init(configuration: Configuration, selectedTab: Int) {
    self.configuration = configuration
    self.selectedTab = selectedTab
  }
}

enum AppAction {
  case tabbedView(TabbedViewAction)

  var tabbedView: TabbedViewAction? {
    get {
      guard case let .tabbedView(value) = self else { return nil }
      return value
    }
    set {
      guard case .tabbedView = self, let newValue = newValue else { return }
      self = .tabbedView(newValue)
    }
  }
}

extension AppState {
  var tabbedView: TabbedViewState {
    get {
      TabbedViewState(
        configuration: self.configuration,
        selectedTab: self.selectedTab
      )
    }
    set {
      self.configuration = newValue.configuration
      self.selectedTab = newValue.selectedTab
    }
  }
}

let appReducer = combine(
  pullback(
    tabbedViewReducer,
    value: \AppState.tabbedView,
    action: \AppAction.tabbedView
  )
)

struct ContentView: View {
  @ObservedObject var store: Store<AppState, AppAction>

  var body: some View {
    TabbedView(
      store: self.store.view(
        value: { $0.tabbedView },
        action: { .tabbedView($0) }
      )
    )
  }
}
