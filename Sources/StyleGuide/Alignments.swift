import SwiftUI

extension HorizontalAlignment {
  private enum TrailingLabel: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat { context[.trailing] }
  }

  public static let trailingLabel = HorizontalAlignment(TrailingLabel.self)
}

extension VerticalAlignment {
  private enum CenterNonSiblings: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[VerticalAlignment.center]
    }
  }

  public static let centerNonSiblings = VerticalAlignment(CenterNonSiblings.self)
}
