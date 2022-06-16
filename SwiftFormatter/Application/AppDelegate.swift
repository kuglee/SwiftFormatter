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
            didRunBefore: getDidRunBefore(),
            useAutodiscovery: getUseAutodiscovery()
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
