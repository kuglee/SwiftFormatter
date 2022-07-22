import AppConstants
import AppFeature
import ComposableArchitecture
import ConfigurationManager
import SwiftUI

@main struct MainApp {
  static func main() {
    if #available(macOS 13.0, *) {
      AppMacOS13.main()
    }
    else {
      AppMacOS12.main()
    }
  }
}

let windowGroup: some Scene = WindowGroup {
  AppView(
    store: Store(
      initialState: AppState(
        configuration: loadConfiguration(fromFileAtPath: AppConstants.configFileURL),
        didRunBefore: getDidRunBefore(),
        shouldTrimTrailingWhitespace: getShouldTrimTrailingWhitespace()
      ),
      reducer: appReducer.saveMiddleware(),
      environment: ()
    )
  )
  .onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
}
.commands { CommandGroup(replacing: .newItem, addition: {}) }

@available(macOS 13.0, *) struct AppMacOS13: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    windowGroup.windowResizability(.contentSize)
  }
}

struct AppMacOS12: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene { windowGroup }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApplication.shared.windows.first?.styleMask = [.titled, .closable, .miniaturizable]
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

extension Reducer where State == AppState, Action == AppAction, Environment == Void {
  func saveMiddleware() -> Reducer {
    .init { state, action, environment in
      switch action {
      case .settingsView(.formatterSettingsView(.trimTrailingWhitespaceFilledOut(_))):
        let effects = self(&state, action, environment)
        let newState = state

        return .concatenate(
          .fireAndForget {
            setShouldTrimTrailingWhitespace(newValue: newState.shouldTrimTrailingWhitespace)
          },
          effects
        )
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
