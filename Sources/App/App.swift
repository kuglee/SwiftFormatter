import AppFeature
import AppUserDefaults
import ComposableArchitecture
import SwiftUI
import WelcomeFeature

public struct App {
  public static func main() {
    if #available(macOS 13.0, *) { AppMacOS13.main() } else { AppMacOS12.main() }
  }
}

let appStore = Store(
  initialState: AppFeature.State(
    configuration: AppUserDefaults.live.getConfiguration(),
    didRunBefore: AppUserDefaults.live.getDidRunBefore(),
    shouldTrimTrailingWhitespace: AppUserDefaults.live.getShouldTrimTrailingWhitespace()
  ),
  reducer: AppFeature().saveSettings()
)

@available(macOS 13.0, *) struct AppMacOS13: SwiftUI.App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      AppViewMacOS13(store: appStore).onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
    }
    .commands { CommandGroup(replacing: .newItem, addition: {}) }.windowResizability(.contentSize)

    Window("Welcome to Swift Formatter", id: "welcome") {
      WelcomeFeatureView(
        store: Store(initialState: WelcomeFeature.State(), reducer: WelcomeFeature())
      )
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

extension ReducerProtocol<AppFeature.State, AppFeature.Action> {
  func saveSettings() -> SaveSettings<Self> { SaveSettings(upstream: self) }
}

struct SaveSettings<Upstream: ReducerProtocol<AppFeature.State, AppFeature.Action>>:
  ReducerProtocol
{
  @Dependency(\.appUserDefaults) var appUserDefaults

  let upstream: Upstream

  var body: some ReducerProtocol<AppFeature.State, AppFeature.Action> {
    self.upstream
    Reduce { state, action in
      switch action {
      case .settingsFeature(.formatterSettings(.binding(\.$shouldTrimTrailingWhitespace))):
        self.appUserDefaults.setShouldTrimTrailingWhitespace(state.shouldTrimTrailingWhitespace)

        return .none
      case .settingsFeature(.formatterRules), .settingsFeature(.formatterSettings):
        self.appUserDefaults.setConfiguration(state.configuration)

        return .none
      case .settingsFeature(_): return .none
      case .setDidRunBefore:
        self.appUserDefaults.setDidRunBefore(state.didRunBefore)

        return .none
      }
    }
  }
}
