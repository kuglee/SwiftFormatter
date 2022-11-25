import ComposableArchitecture
import StyleGuide
import SwiftUI
import XCTestDynamicOverlay

public struct WelcomeFeature: ReducerProtocol {
  @Dependency(\.workspace) var workspace

  public init() {}

  public struct State: Equatable {
    public var isDismissed: Bool

    public init(isDismissed: Bool = false) { self.isDismissed = isDismissed }
  }

  public enum Action {
    case openExtensionsSettings
    case closeButtonTapped
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .openExtensionsSettings:
        return .run { _ in await self.workspace.openExtensionsPreferences() }
      case .closeButtonTapped:
        state.isDismissed = true

        return .none
      }
    }
  }
}

public enum WorkspaceKeys: DependencyKey {
  public static let liveValue = Workspace.live
  public static let testValue = Workspace.unimplemented
}

extension DependencyValues {
  public var workspace: Workspace {
    get { self[WorkspaceKeys.self] }
    set { self[WorkspaceKeys.self] = newValue }
  }
}

public struct Workspace { public var openExtensionsPreferences: () async -> Void }

extension Workspace {
  public static let live = Self(openExtensionsPreferences: {
    let urlString: String = {
      if #available(macOS 13.0, *) {
        return "x-apple.systempreferences:com.apple.ExtensionsPreferences"
      } else {
        return "/System/Library/PreferencePanes/Extensions.prefPane"
      }
    }()

    NSWorkspace.shared.open(URL(string: urlString)!)
  })
}

extension Workspace {
  public static let unimplemented = Self(
    openExtensionsPreferences: XCTUnimplemented("\(Self.self).openExtensionsPreferences")
  )
}

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
  let store: StoreOf<WelcomeFeature>

  public init(store: StoreOf<WelcomeFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 0) {
        VStack(spacing: .grid(9)) {
          Image(systemName: "square.and.pencil").resizable().aspectRatio(contentMode: .fit)
            .frame(height: 46).foregroundColor(.accentColor)
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
          Button(action: { viewStore.send(.openExtensionsSettings) }) {
            Text("Open \(SettingsStrings.systemSettingsName)")
          }
          .buttonStyle(.link)
          Button(action: { viewStore.send(.closeButtonTapped) }) {
            Text("Continue").frame(minWidth: 84)
          }
          .controlSize(.large).keyboardShortcut(.defaultAction)
        }
        .padding(.top, .grid(14))
      }
    }
    .padding(.top, .grid(18)).padding(.bottom, .grid(8)).frame(width: 510, alignment: .top)
  }
}

public struct WelcomeFeatureView_Previews: PreviewProvider {
  public static var previews: some View {
    WelcomeFeatureView(
      store: Store(initialState: WelcomeFeature.State(), reducer: WelcomeFeature())
    )
  }
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
