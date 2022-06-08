import ComposableArchitecture
import StyleGuide
import SwiftFormatConfiguration
import SwiftUI
import Utility

extension FileScopedDeclarationPrivacyConfiguration.AccessLevel {
  public typealias RawValue = String

  public init?(rawValue: RawValue) { return nil }

  public var rawValue: RawValue {
    switch self {
    case .`private`: return "Private"
    case .`fileprivate`: return "Fileprivate"
    }
  }
}

public enum FileScopedDeclarationPrivacyViewAction: Equatable {
  case accessLevelSelected(FileScopedDeclarationPrivacyConfiguration.AccessLevel)
}

public struct FileScopedDeclarationPrivacyViewState {
  public var accessLevel: FileScopedDeclarationPrivacyConfiguration.AccessLevel

  public init(accessLevel: FileScopedDeclarationPrivacyConfiguration.AccessLevel) {
    self.accessLevel = accessLevel
  }
}

public func fileScopedDeclarationPrivacyViewReducer(
  state: inout FileScopedDeclarationPrivacyViewState, action: FileScopedDeclarationPrivacyViewAction
) -> [Effect<FileScopedDeclarationPrivacyViewAction>] {
  switch action {
  case .accessLevelSelected(let value): state.accessLevel = value
  }

  return []
}

public struct FileScopedDeclarationPrivacyViewView: View {
  @ObservedObject var store:
    Store<FileScopedDeclarationPrivacyViewState, FileScopedDeclarationPrivacyViewAction>

  public init(
    store: Store<FileScopedDeclarationPrivacyViewState, FileScopedDeclarationPrivacyViewAction>
  ) { self.store = store }

  public var body: some View {
    HStack(alignment: .centerAlignmentGuide, spacing: 0) {
      Text("File Scoped Declaration Privacy:").modifier(TrailingAlignmentStyle()).modifier(
        CenterAlignmentStyle())
      Picker(
        "",
        selection: Binding(
          get: { self.store.value.accessLevel }, set: { self.store.send(.accessLevelSelected($0)) })
      ) {
        Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.`private`.rawValue).tag(
          FileScopedDeclarationPrivacyConfiguration.AccessLevel.`private`)
        Text(FileScopedDeclarationPrivacyConfiguration.AccessLevel.`fileprivate`.rawValue).tag(
          FileScopedDeclarationPrivacyConfiguration.AccessLevel.`fileprivate`)
      }.toolTip(
        "Determines the formal access level (i.e., the level specified in source code) for file-scoped declarations whose effective access level is private to the containing file."
      ).modifier(PrimaryPickerStyle())
    }
  }
}
