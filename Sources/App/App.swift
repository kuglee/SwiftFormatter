import AppAssets
import AppFeature
import ComposableArchitecture
import SwiftUI

public struct App: SwiftUI.App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  public init() {}

  public var body: some Scene {
    WindowGroup {
      AppFeatureView(store: Store(initialState: AppFeature.State(), reducer: { AppFeature() }))
        .onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
    }
    .commands { CommandGroup(replacing: .newItem, addition: {}) }.contentSizedWindowResizability()
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  var interfaceStyle: InterfaceStyle {
    let type = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Unspecified"
    return InterfaceStyle(rawValue: type) ?? InterfaceStyle.Unspecified
  }

  func setAppIcon() {
    NSApplication.shared.applicationIconImage = NSImage(
      named: self.interfaceStyle != .Dark ? "AppIconLight" : "AppIcon",
      in: AppAssets.bundle
    )!
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApplication.shared.windows.first?.styleMask = [.titled, .closable, .miniaturizable]

    // always open in front
    NSApplication.shared.activate(ignoringOtherApps: true)

    self.setAppIcon()

    DistributedNotificationCenter.default.addObserver(
      forName: .AppleInterfaceThemeChangedNotification,
      object: nil,
      queue: OperationQueue.main
    ) { _ in self.setAppIcon() }
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

enum InterfaceStyle: String {
  case Light
  case Dark
  case Unspecified
}

extension Notification.Name {
  static let AppleInterfaceThemeChangedNotification = Notification.Name(
    "AppleInterfaceThemeChangedNotification"
  )
}
