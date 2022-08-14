import SwiftUI

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
