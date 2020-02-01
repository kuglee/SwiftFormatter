import SwiftUI
import Utility

public struct AboutView: View {
  internal struct InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  public init() {}

  public var body: some View {
    VStack(spacing: 16) {
      Text("How to use").font(.headline)
      Text("Go to", bundle: InternalConstants.bundle)
        + Text(" ")
        + Text("Settings", bundle: InternalConstants.bundle).bold()
        + Text(" -> ")
        + Text("Extensions", bundle: InternalConstants.bundle).bold()
        + Text(" ")
        + Text("and enable", bundle: InternalConstants.bundle)
        + Text(" ")
        + Text("Swift-format", bundle: InternalConstants.bundle).bold()
    }.frame(minHeight:0, maxHeight: .infinity, alignment: .top)
  }
}
