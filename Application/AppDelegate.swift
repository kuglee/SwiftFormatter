import ComposableArchitecture
import ConfigurationManager
import SwiftUI

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {
  var window: NSWindow!
  var contentView: ContentView? = nil
  var didRunBefore = false

  let configFileURL: URL = FileManager.default
    .urls(for: .libraryDirectory, in: .userDomainMask).first!
    .appendingPathComponent("Preferences/swift-format.json")

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 700),
      styleMask: [
        .titled, .closable, .miniaturizable, .resizable, .fullSizeContentView,
      ],
      backing: .buffered,
      defer: false
    )
    window.center()
    window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isEnabled =
      false
    window.setFrameAutosaveName("Main Window")
    window.title = "Swift-format"

    didRunBefore = self.getDidRunBefore()
    let selectedTab = !self.didRunBefore ? 2 : 0

    contentView = ContentView(
      store: Store(
        initialValue: AppState(
          configuration: loadConfiguration(fromFileAtPath: configFileURL),
          selectedTab: selectedTab
        ),
        reducer: appReducer
      )
    )

    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    dumpConfiguration(
      configuration: contentView!.store.value.configuration,
      outputFileURL: configFileURL
    )

    if !self.didRunBefore { self.setDidRunBefore() }
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication)
    -> Bool
  { true }

  func getDidRunBefore() -> Bool {
    let userDefaults = UserDefaults.standard

    return userDefaults.bool(forKey: "didRunBefore")
  }

  func setDidRunBefore() {
    let userDefaults = UserDefaults.standard
    userDefaults.set(true, forKey: "didRunBefore")
  }
}
