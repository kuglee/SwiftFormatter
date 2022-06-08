import ComposableArchitecture
import ConfigurationManager
import SwiftFormatConfiguration
import SwiftUI
import Utility

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {
  var window: NSWindow!
  var contentView: ContentView? = nil
  var didRunBefore = false

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 700),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isEnabled = false
    window.setFrameAutosaveName("Main Window")
    window.title = "Swift-format"

    didRunBefore = self.getDidRunBefore()
    let selectedTab = !self.didRunBefore ? 2 : 0

    contentView = ContentView(
      store: Store(
        initialValue: AppState(
          configuration: loadConfiguration(fromFileAtPath: AppConstants.configFileURL),
          selectedTab: selectedTab), reducer: with(appReducer, saveMiddleware)))

    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    if !self.didRunBefore { self.setDidRunBefore() }
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }

  func getDidRunBefore() -> Bool {
    let userDefaults = UserDefaults.standard

    return userDefaults.bool(forKey: "didRunBefore")
  }

  func setDidRunBefore() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(true, forKey: "didRunBefore")
  }
}
