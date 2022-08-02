import AppFeature
import AppUserDefaults
import ComposableArchitecture
import Defaults
import StyleGuide
import SwiftUI

public struct App {
  public static func main() {
    if #available(macOS 13.0, *) { AppMacOS13.main() } else { AppMacOS12.main() }
  }
}

let appStore = Store(
  initialState: AppState(
    configuration: Defaults[.configuration],
    didRunBefore: Defaults[.didRunBefore],
    shouldTrimTrailingWhitespace: Defaults[.shouldTrimTrailingWhitespace]
  ),
  reducer: appReducer.saveMiddleware(),
  environment: ()
)

@available(macOS 13.0, *) struct AppMacOS13: SwiftUI.App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      AppViewMacOS13(store: appStore).onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
    }
    .commands { CommandGroup(replacing: .newItem, addition: {}) }.windowResizability(.contentSize)

    Window("Welcome to Swift Formatter", id: "welcome") {
      VStack(alignment: .leading, spacing: .grid(4)) {
        VStack(alignment: .leading, spacing: .grid(2)) {
          Text("How to enable").bold()
          Text(
            "Choose Apple menu  > System Settings > Privacy & Security > Extensions > Xcode Source Editor and enable the Swift Formatter extension."
          )
        }
        VStack(alignment: .leading, spacing: .grid(2)) {
          Text("How to use").bold()
          Text("In Xcode choose Editor > Swift Formatter > Format Source from the menu bar.")
        }
      }
      .padding().frame(width: 520, height: 300, alignment: .top)
    }
    .windowResizability(.contentSize)
  }
}

struct AppMacOS12: SwiftUI.App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      AppViewMacOS12(store: appStore).onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
    }
    .commands { CommandGroup(replacing: .newItem, addition: {}) }
  }
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
      case .settingsView(.formatterSettingsView(.binding(\.$shouldTrimTrailingWhitespace))):
        let effects = self(&state, action, environment)
        let newState = state

        return .concatenate(
          .fireAndForget {
            Defaults[.shouldTrimTrailingWhitespace] = newState.shouldTrimTrailingWhitespace
          },
          effects
        )
      case .settingsView:
        let effects = self(&state, action, environment)
        let newState = state

        return .concatenate(
          .fireAndForget { Defaults[.configuration] = newState.configuration },
          effects
        )
      case .setDidRunBefore:
        let effects = self(&state, action, environment)
        let newState = state

        return .concatenate(
          .fireAndForget { Defaults[.didRunBefore] = newState.didRunBefore },
          effects
        )
      }
    }
  }
}
