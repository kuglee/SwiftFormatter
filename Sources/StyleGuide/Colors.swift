import SwiftUI

extension Color {
  public static var borderColor = Self(
    light: Color(nsColor: .lightGray2),
    dark: Color(nsColor: .darkGray)
  )
}

extension ShapeStyle where Self == Color { public static var borderColor: Color { .borderColor } }

extension Color {
  public init(light: Color, dark: Color) {
    self.init(nsColor: .init(light: light.cgColor!, dark: dark.cgColor!))
  }
}

extension NSColor { public static let lightGray2 = NSColor(white: 192.0 / 255.0, alpha: 1) }

extension NSColor {
  public convenience init(light: CGColor, dark: CGColor) {
    self.init(name: nil) {
      if $0.userInterfaceStyle == .dark {
        Self.init(cgColor: dark)!
      } else {
        Self.init(cgColor: light)!
      }
    }
  }
}

extension NSAppearance {
  enum UserInterfaceStyle {
    case light
    case dark
  }

  var userInterfaceStyle: UserInterfaceStyle {
    if self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua { .dark } else { .light }
  }
}
