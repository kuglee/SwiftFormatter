import SwiftUI

extension CGFloat { public static func grid(_ n: Int) -> CGFloat { .init(n) * 2 } }

// MARK: - Colors

extension NSColor {
  public class func dynamicColor(light: NSColor, dark: NSColor) -> NSColor {
    return NSColor(name: nil) {
      switch $0.name {
      case .darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua,
        .accessibilityHighContrastVibrantDark:
        return dark
      default: return light
      }
    }
  }

  // override with list style colors (bordered(alternatesRowBackgrounds:))
  static let alternatingContentBackgroundColors: [NSColor] = [
    .dynamicColor(light: .white, dark: .init(white: 0.175, alpha: 1)),
    .dynamicColor(light: .init(white: 0.96, alpha: 1), dark: .init(white: 0.21, alpha: 1)),
  ]
}

// MARK: - Alignments

extension HorizontalAlignment {
  private enum TrailingAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat { context[.trailing] }
  }

  public static let trailingAlignmentGuide = HorizontalAlignment(TrailingAlignment.self)
}

public struct TrailingAlignmentStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.alignmentGuide(.trailingAlignmentGuide) { $0[.trailing] }
  }
}

extension VerticalAlignment {
  private enum CenterAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[VerticalAlignment.center]
    }
  }

  public static let centerAlignmentGuide = VerticalAlignment(CenterAlignment.self)
}

public struct CenterAlignmentStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.alignmentGuide(.centerAlignmentGuide) { $0[VerticalAlignment.center] }
  }
}

// MARK: - TextField Styles

public struct PrimaryTextFieldStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.multilineTextAlignment(.trailing).frame(width: 40)
  }
}

// MARK: - Row Styles

public enum AlternatingBackground {
  case dark
  case light
}

public struct AlternatingContentBackground: ViewModifier {
  private var background: AlternatingBackground

  public init(background: AlternatingBackground) { self.background = background }

  public func body(content: Content) -> some View {
    content.padding([.vertical], .grid(2)).padding([.horizontal], .grid(3))
      .background(Color(.alternatingContentBackgroundColors[self.background == .dark ? 0 : 1]))
  }
}

// MARK: - Border Styles

public struct PrimaryListBorderStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.padding(1).border(Color(.placeholderTextColor))
  }
}

// MARK: - Picker Styles

public struct PrimaryPickerStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View { content.frame(maxWidth: 110) }
}

// MARK: - TabView Styles

public struct PrimaryTabViewStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.frame(width: 600, height: 532).padding(.horizontal, .grid(10)).padding(.top, .grid(5))
      .padding(.bottom, .grid(10))
  }
}

// MARK: - TabItem Styles

public struct PrimaryTabItemStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View { content.padding(.grid(6)) }
}

// MARK: - VStack Styles

public struct PrimaryVStackStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.frame(
      minWidth: 0,
      maxWidth: .infinity,
      minHeight: 0,
      maxHeight: .infinity,
      alignment: .top
    )
  }
}

// MARK: - Toggle Styles

public struct PrimaryToggleStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
  }
}

// MARK: - Text Styles

public struct SecondaryTextStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.font(.footnote).foregroundColor(Color.secondary)
  }
}
