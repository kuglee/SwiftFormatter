import Cocoa
import SwiftUI
import os.log
import SwiftFormatConfiguration
import ComposableArchitecture

fileprivate let configFileURL : URL = FileManager.default.urls(
  for: .libraryDirectory,
  in: .userDomainMask
).first!.appendingPathComponent("Preferences/swift-format.json")

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 700),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false
    )
    window.center()
    window.setFrameAutosaveName("Main Window")

    let contentView = ContentView(store: Store(initialValue: AppState(configuration: loadConfiguration(fromFileAtPath: configFileURL)), reducer: appReducer))
    window.contentView = NSHostingView(rootView: contentView)

    window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isEnabled = false
    
    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
//    dumpConfiguration(configuration: configurationWrapper.config, outputFileURL: configFileURL)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

func dumpConfiguration(configuration: Configuration = Configuration(), outputFileURL: URL? = nil) {
  do {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted]
    if #available(macOS 10.13, *) {
      encoder.outputFormatting.insert(.sortedKeys)
    }

    let data = try encoder.encode(configuration)
    guard let jsonString = String(data: data, encoding: .utf8) else {
      print("Could not dump the default configuration: the JSON was not valid UTF-8")
      return
    }
    
    if let outputFileURL = outputFileURL {
      do {
        try jsonString.write(to: outputFileURL, atomically: false, encoding: .utf8)
      } catch {
        print("Could not dump the default configuration: \(error)")
      }
    } else {
      print(jsonString)
    }
  } catch {
    print("Could not dump the default configuration: \(error)")
  }
}
