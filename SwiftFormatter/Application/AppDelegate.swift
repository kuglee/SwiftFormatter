import ComposableArchitecture
import ConfigurationManager
import SwiftFormatConfiguration
import SwiftUI
import Utility

@main struct SwiftFormatApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(
          initialState: AppState(
            configuration: loadConfiguration(fromFileAtPath: AppConstants.configFileURL),
            didRunBefore: getDidRunBefore()), reducer: appReducer.saveMiddleware(), environment: ())
      )
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApplication.shared.windows.first?.styleMask = [.titled, .closable, .miniaturizable]
  }
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}
