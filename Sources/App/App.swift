import AppFeature
import ComposableArchitecture
import SwiftUI

public struct App: SwiftUI.App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  public init() {}

  public var body: some Scene {
    WindowGroup {
      AppFeatureView(store: Store(initialState: AppFeature.State(), reducer: AppFeature()))
        .onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
    }
    .commands { CommandGroup(replacing: .newItem, addition: {}) }.contentSizedWindowResizability()
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApplication.shared.windows.first?.styleMask = [.titled, .closable, .miniaturizable]
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

extension Scene {
  func contentSizedWindowResizability() -> some Scene {
    if #available(macOS 13.0, *) {
      return self.windowResizability(.contentSize)
    } else {
      return self
    }
  }
}
