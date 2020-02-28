import SwiftUI

extension CGFloat {
  public static func grid(_ n: Int) -> CGFloat {
    return CGFloat(n) * 3
  }
}

// MARK: - Alignments

extension HorizontalAlignment {
  private enum TrailingAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[.leading]
    }
  }

  public static let trailingAlignmentGuide = HorizontalAlignment(
    TrailingAlignment.self
  )
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

  public static let centerAlignmentGuide = VerticalAlignment(
    CenterAlignment.self
  )
}

public struct CenterAlignmentStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.alignmentGuide(.centerAlignmentGuide) {
      $0[VerticalAlignment.center]
    }
  }
}

// MARK: - TextField Styles

public struct PrimaryTextFieldStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.multilineTextAlignment(.trailing).frame(width: 40)
  }
}

public enum AlternatingBackground {
  case dark
  case light
}

// MARK: - Background Styles

public struct PrimaryListBackgroundStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.listRowBackground(
      Color(NSColor.alternatingContentBackgroundColors[0])
    )
  }
}

public struct SecondaryListBackgroundStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.listRowBackground(
      Color(NSColor.alternatingContentBackgroundColors[1])
    )
  }
}

public struct AlternatingListBackgroundStyle: ViewModifier {
  private var background: AlternatingBackground

  public init(background: AlternatingBackground) {
    self.background = background
  }

  public func body(content: Content) -> some View {
    switch background {
    case .dark: return AnyView(content.modifier(PrimaryListBackgroundStyle()))
    case .light:
      return AnyView(content.modifier(SecondaryListBackgroundStyle()))
    }
  }
}

// MARK: - Border Styles

public struct PrimaryListBorderStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.border(Color(.placeholderTextColor))
  }
}

// MARK: - Picker Styles

public struct PrimaryPickerStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.frame(maxWidth: 110)
  }
}

// MARK: - TabView Styles

public struct PrimaryTabViewStyle: ViewModifier {
  public init() {}

  public func body(content: Content) -> some View {
    content.frame(width: 600, height: 500)
  }
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
