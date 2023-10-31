import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  public func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label.padding(4).font(.system(size: 17, weight: .light))
      .foregroundColor(
        configuration.isPressed
          ? Color.primary
          : self.isEnabled ? Color.secondary : Color(nsColor: .disabledControlTextColor)
      )
      .contentShape(Rectangle())
  }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
  public static var primary: Self { .init() }
}
