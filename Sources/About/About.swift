import StyleGuide
import SwiftUI
import Utility

public struct AboutView: View {
  public init() {}

  public var body: some View {
    VStack(alignment: .leading, spacing: .grid(4)) {
      VStack(alignment: .leading, spacing: .grid(2)) {
        Text("How to install").bold()
        Text(
          "Choose Apple menu  > System Preferences, then click Extensions and enable the Swift Formatter extension."
        )
      }
      VStack(alignment: .leading, spacing: .grid(2)) {
        Text("How to use").bold()
        Text("In Xcode choose Editor > Swift Formatter > Format Source from the menu bar.")
      }
    }
    .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
  }
}
