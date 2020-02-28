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
  state: inout FileScopedDeclarationPrivacyViewState,
  action: FileScopedDeclarationPrivacyViewAction
) -> [Effect<FileScopedDeclarationPrivacyViewAction>] {
  switch action {
  case .accessLevelSelected(let value):
    state.accessLevel = value
  }

  return []
}

public struct FileScopedDeclarationPrivacyViewView: View {
  internal enum InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  @ObservedObject var store:
    Store<FileScopedDeclarationPrivacyViewState, FileScopedDeclarationPrivacyViewAction>

  public init(
    store: Store<FileScopedDeclarationPrivacyViewState, FileScopedDeclarationPrivacyViewAction>
  ) {
    self.store = store
  }

  public var body: some View {
    HStack(alignment: .centerAlignmentGuide, spacing: 0) {
      Text("FileScopedDeclarationPrivacy:", bundle: InternalConstants.bundle)
        .modifier(TrailingAlignmentStyle()).modifier(CenterAlignmentStyle())
      Picker(
        "",
        selection: Binding(
          get: { self.store.value.accessLevel },
          set: { self.store.send(.accessLevelSelected($0)) }
        )
      ) {
        Text(
          LocalizedStringKey(
            FileScopedDeclarationPrivacyConfiguration.AccessLevel.`private`.rawValue),
          bundle: InternalConstants.bundle
        )
        .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.`private`)
        Text(
          LocalizedStringKey(
            FileScopedDeclarationPrivacyConfiguration.AccessLevel.`fileprivate`.rawValue),
          bundle: InternalConstants.bundle
        )
        .tag(FileScopedDeclarationPrivacyConfiguration.AccessLevel.`fileprivate`)
      }
      .toolTip(
        "FILE_SCOPED_DECLARATION_PRIVACY_ACCESS_LEVEL",
        bundle: InternalConstants.bundle
      )
      .modifier(PrimaryPickerStyle())
    }
  }
}
