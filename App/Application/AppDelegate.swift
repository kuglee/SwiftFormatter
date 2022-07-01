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
            configuration: loadConfiguration(fromFileAtPath: AppConstants.configFileURL),
            didRunBefore: getDidRunBefore(),
            useConfigurationAutodiscovery: getUseConfigurationAutodiscovery()
          ),
          reducer: appReducer.saveMiddleware(),
          environment: ()
        )
      )
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApplication.shared.windows.first?.styleMask = [.titled, .closable, .miniaturizable]

    // disable default focus
    NSApplication.shared.windows.first?.makeFirstResponder(nil)
    NSApplication.shared.windows.first?.resignFirstResponder()
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
          .fireAndForget {
            dumpConfiguration(
              configuration: newState.configuration,
              outputFileURL: AppConstants.configFileURL,
              createIntermediateDirectories: true
            )
          },
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

func getUseConfigurationAutodiscovery() -> Bool {
  UserDefaults(suiteName: AppConstants.appGroupName)!
    .bool(forKey: AppConstants.useConfigurationAutodiscoveryKey)
}
