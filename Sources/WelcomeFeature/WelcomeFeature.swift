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
  static let systemSettingsString: String = {
    if #available(macOS 13.0, *) { return "System Settings" } else { return "System Preferences" }
  }()

  static let extensionsPathString: String = {
    if #available(macOS 13.0, *) {
      return "\(systemSettingsString) > Privacy & Security > Extensions"
    } else {
      return "\(systemSettingsString) > Extensions"
    }
  }()
}

public struct WelcomeFeatureView: View {
  let store: StoreOf<WelcomeFeature>

  public init(store: StoreOf<WelcomeFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: .grid(4)) {
        Text(
          "Before Swift Formatter can be used in Xcode its extension must be enabled in \(SettingsStrings.systemSettingsString)"
        )
        VStack(spacing: .grid(3)) {
          Text("Enabling the Extension").font(.system(.headline))
          VStack(spacing: .grid(2)) {
            Text(
              "The extension can be enabled and disabled in \(SettingsStrings.extensionsPathString) > Xcode Source Editor"
            )
            Button(action: { viewStore.send(.openExtensionsSettings) }) {
              Text("Open \(SettingsStrings.extensionsPathString)")
            }
          }
        }
        VStack(spacing: .grid(3)) {
          Text("Using the Extension").font(.system(.headline))
          Text(
            "To use the extension in Xcode choose Editor > Swift Formatter > Format Source from the menu bar."
          )
        }
        Button(action: { viewStore.send(.closeButtonTapped) }) { Text("Close") }
          .padding(.top, .grid(3))
      }
      .multilineTextAlignment(.center).padding().frame(width: 500, height: 320, alignment: .top)
    }
  }
}
