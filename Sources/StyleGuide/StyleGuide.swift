import SwiftUI

extension CGFloat { public static func grid(_ n: Int) -> CGFloat { return CGFloat(n) * 2 } }

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
    NSColor.dynamicColor(light: NSColor.white, dark: NSColor.init(white: 0.175, alpha: 1)),
    NSColor.dynamicColor(
      light: NSColor.init(white: 0.96, alpha: 1),
      dark: NSColor.init(white: 0.21, alpha: 1)
    ),
  ]
}

// MARK: - Alignments

extension HorizontalAlignment {
  private enum TrailingAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat { context[.leading] }
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

public struct BaseRowStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.padding([.vertical], .grid(2)).padding([.horizontal], .grid(3))
  }
}

public struct PrimaryRowBackgroundStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.background(Color(NSColor.alternatingContentBackgroundColors[0]))
  }
}

public struct SecondaryRowBackgroundStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.background(Color(NSColor.alternatingContentBackgroundColors[1]))
  }
}

public struct AlternatingRowBackgroundStyle: ViewModifier {
  private var background: AlternatingBackground

  public init(background: AlternatingBackground) { self.background = background }

  public func body(content: Content) -> some View {
    switch background {
    case .dark: return AnyView(content.modifier(PrimaryRowBackgroundStyle()))
    case .light: return AnyView(content.modifier(SecondaryRowBackgroundStyle()))
    }
  }
}

public struct AlternatingRowStyle: ViewModifier {
  private var background: AlternatingBackground

  public init(background: AlternatingBackground) { self.background = background }

  public func body(content: Content) -> some View {
    content.modifier(BaseRowStyle())
      .modifier(AlternatingRowBackgroundStyle(background: self.background))
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
