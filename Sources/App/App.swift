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
  initialState: AppFeature.State(
    configuration: Defaults[.configuration],
    didRunBefore: Defaults[.didRunBefore],
    shouldTrimTrailingWhitespace: Defaults[.shouldTrimTrailingWhitespace]
  ),
  reducer: AppFeature().saveMiddleware()
)

@available(macOS 13.0, *) struct AppMacOS13: SwiftUI.App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      AppViewMacOS13(store: appStore).onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
    }
    .commands { CommandGroup(replacing: .newItem, addition: {}) }.windowResizability(.contentSize)

    Window("Welcome to Swift Formatter", id: "welcome") {
      VStack(spacing: .grid(4)) {
        Text(
          "Before Swift Formatter can be used in Xcode its extension must be enabled in System Settings."
        )
        VStack(spacing: .grid(3)) {
          Text("Enabling the Extension").font(.system(.headline))
          VStack(spacing: .grid(2)) {
            Text(
              "The extension can be enabled and disabled in System Settings > Privacy & Security > Extensions > Xcode Source Editor"
            )
            Button(action: {
              NSWorkspace.shared.open(
                URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences")!
              )
            }) { Text("Open System Settings > Privacy & Security > Extensions") }
            .frame(maxWidth: .infinity)
          }
        }
        VStack(spacing: .grid(3)) {
          Text("Using the Extension").font(.system(.headline))
          Text(
            "To use the extension in Xcode choose Editor > Swift Formatter > Format Source from the menu bar."
          )
        }
      }
      .multilineTextAlignment(.center).padding().frame(width: 500, height: 300, alignment: .top)
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
  func saveMiddleware() -> SaveMiddleware<Self> { SaveMiddleware(upstream: self) }
}

struct SaveMiddleware<Upstream: ReducerProtocol<AppFeature.State, AppFeature.Action>>:
  ReducerProtocol
{
  let upstream: Upstream

  var body: some ReducerProtocol<AppFeature.State, AppFeature.Action> {
    self.upstream
    Reduce { state, action in
      switch action {
      case .settingsFeature(.formatterSettings(.binding(\.$shouldTrimTrailingWhitespace))):
        return .run { [state] _ in
          Defaults[.shouldTrimTrailingWhitespace] = state.shouldTrimTrailingWhitespace
        }
      case .settingsFeature:
        return .run { [state] _ in Defaults[.configuration] = state.configuration }
      case .setDidRunBefore:
        return .run { [state] _ in Defaults[.didRunBefore] = state.didRunBefore }
      }
    }
  }
}
