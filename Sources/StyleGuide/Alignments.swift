import SwiftUI

extension HorizontalAlignment {
  private enum TrailingLabelAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat { context[.trailing] }
  }

  public static let trailingLabel = HorizontalAlignment(TrailingLabelAlignment.self)
}

extension VerticalAlignment {
  private enum CenterNonSiblingsAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[VerticalAlignment.center]
    }
  }

  public static let centerNonSiblings = VerticalAlignment(CenterNonSiblingsAlignment.self)
}
