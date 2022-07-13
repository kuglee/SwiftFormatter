import App
import AppConstants
import ComposableArchitecture
import ConfigurationManager
import SwiftFormatConfiguration
import SwiftUI

@main struct SwiftFormatApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      AppView(
        store: Store(
          initialState: AppState(
            configuration: loadConfiguration(fromJSON: getConfiguration()),
            didRunBefore: getDidRunBefore()
          ),
          reducer: appReducer.saveMiddleware(),
          environment: ()
        )
      )
    }
    .commands { CommandGroup(replacing: .newItem, addition: {}) }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApplication.shared.windows.first?.styleMask = [.titled, .closable, .miniaturizable]
    NSApplication.shared.windows.first?.tabbingMode = .disallowed
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

extension Reducer where State == AppState, Action == AppAction, Environment == Void {
  func saveMiddleware() -> Reducer {
    .init { state, action, environment in
      switch action {
      case .settingsView:
        let effects = self(&state, action, environment)
        let newState = state
        return .concatenate(
          .fireAndForget { dumpConfiguration(configuration: newState.configuration) },
          effects
        )
      default: return self(&state, action, environment)
      }
    }
  }
}

func getDidRunBefore() -> Bool {
  UserDefaults(suiteName: AppConstants.appGroupName)!.bool(forKey: AppConstants.didRunBeforeKey)
}
