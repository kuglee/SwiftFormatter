import AppAssets
import StyleGuide
import SwiftUI

enum SettingsStrings {
  static let systemSettingsName: String = {
    if #available(macOS 13.0, *) { return "System Settings" } else { return "System Preferences" }
  }()

  static let settingsURL: String = {
    if #available(macOS 13.0, *) {
      return "x-apple.systempreferences:com.apple.ExtensionsPreferences"
    } else {
      return "/System/Library/PreferencePanes/Extensions.prefPane"
    }
  }()!
}

public struct WelcomeFeatureView: View {
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @Environment(\.presentationMode) @Binding var presentationMode

  public init() {}

  public var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: .grid(9)) {
        Image(
          nsImage: NSImage(
            named: self.colorScheme != .dark ? "AppIconLight" : "AppIcon",
            in: AppAssets.bundle
          )!
        )
        .resizable().aspectRatio(contentMode: .fit).frame(height: 72)
        Text("Welcome to Swift Formatter").font(.largeTitle).multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
        VStack(alignment: .leading, spacing: .grid(5)) {
          EqualIconWidthDomain {
            WelcomeItemView(
              title: "Enabling the Extension",
              subtitle:
                "Before Swift Formatter can be used in Xcode its extension must be enabled in \(SettingsStrings.systemSettingsName).",
              image: Image(systemName: "gear")
            )
            WelcomeItemView(
              title: "Using the Extension",
              subtitle:
                "To use the extension in Xcode choose Editor > Swift Formatter > Format Source from the menu bar.",
              image: Image(systemName: "filemenu.and.selection")
            )
          }
        }
        .padding(.leading, .grid(15)).padding(.trailing, .grid(18))
      }
      VStack(spacing: .grid(3)) {
        Text(.init("[Open \(SettingsStrings.systemSettingsName)](\(SettingsStrings.settingsURL))"))
        Button(action: { self.presentationMode.dismiss() }) { Text("Continue").frame(minWidth: 84) }
          .controlSize(.large).keyboardShortcut(.defaultAction)
      }
      .padding(.top, .grid(14))
    }
    .padding(.top, .grid(18)).padding(.bottom, .grid(8)).frame(width: 510, alignment: .top)
  }
}

public struct WelcomeFeatureView_Previews: PreviewProvider {
  public static var previews: some View { WelcomeFeatureView() }
}

struct WelcomeItemView: View {
  let title: String
  let subtitle: String
  let image: Image

  init(title: String, subtitle: String, image: Image) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
  }

  var body: some View {
    Label {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text("\(self.title)").bold().foregroundColor(.primary)
          .fixedSize(horizontal: false, vertical: true)
        Text(self.subtitle).fixedSize(horizontal: false, vertical: true)
      }
    } icon: {
      self.image.resizable().aspectRatio(contentMode: .fit).frame(width: 28)
        .foregroundColor(.accentColor).padding(.trailing)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    .multilineTextAlignment(.leading)
  }
}
