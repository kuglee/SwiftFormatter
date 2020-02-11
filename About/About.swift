import SwiftUI
import Utility

public struct AboutView: View {
  internal enum InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  public init() {}

  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack(alignment: .leading, spacing: 6) {
        Text("How to install").bold()
        Text(
          "Choose Apple menu  > System Preferences, then click Extensions and enable the Swift-format extension.",
          bundle: InternalConstants.bundle
        )
      }
      VStack(alignment: .leading, spacing: 6) {
        Text("How to use").bold()
        Text(
          "In Xcode choose Editor > Swift-format > Format Source from the menu bar.",
          bundle: InternalConstants.bundle
        )
      }
    }
    .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
  }
}
