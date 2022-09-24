import ComposableArchitecture
import StyleGuide
import SwiftUI
import XCTestDynamicOverlay

public struct WelcomeFeature: ReducerProtocol {
  @Dependency(\.workspace) var workspace

  public init() {}

  public struct State: Equatable { public init() {} }

  public enum Action { case openExtensionsSettings }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .openExtensionsSettings:
        return .run { _ in await self.workspace.openExtensionsPreferences() }
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
    NSWorkspace.shared.open(
      URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences")!
    )
  })
}

extension Workspace {
  public static let unimplemented = Self(
    openExtensionsPreferences: XCTUnimplemented("\(Self.self).openExtensionsPreferences")
  )
}

@available(macOS 13.0, *) public struct WelcomeFeatureView: View {
  let store: StoreOf<WelcomeFeature>
  @Environment(\.openWindow) private var openWindow

  public init(store: StoreOf<WelcomeFeature>) { self.store = store }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: .grid(4)) {
        Text(
          "Before Swift Formatter can be used in Xcode its extension must be enabled in System Settings."
        )
        VStack(spacing: .grid(3)) {
          Text("Enabling the Extension").font(.system(.headline))
          VStack(spacing: .grid(2)) {
            Text(
              "The extension can be enabled and disabled in System Settings > Privacy & Security > Extensions > Xcode Source Editor"
            )
            Button(action: { viewStore.send(.openExtensionsSettings) }) {
              Text("Open System Settings > Privacy & Security > Extensions")
            }
            .frame(maxWidth: .infinity)
          }
        }
        VStack(spacing: .grid(3)) {
          Text("Using the Extension").font(.system(.headline))
          Text(
            "To use the extension in Xcode choose Editor > Swift Formatter > Format Source from the menu bar."
          )
        }
      }
      .multilineTextAlignment(.center).padding().frame(width: 500, height: 300, alignment: .top)
    }
  }
}
