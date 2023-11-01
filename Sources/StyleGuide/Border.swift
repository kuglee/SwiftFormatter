import SwiftUI

extension View {
  public func border<S>(_ edges: Edge.Set, _ content: S, width: CGFloat = 1) -> some View
  where S: ShapeStyle {
    self.overlay { CustomBorderShape(edges: edges, width: width).stroke(content, lineWidth: width) }
  }
}

struct CustomBorderShape: Shape {
  let edges: Edge.Set
  let width: CGFloat

  init(edges: Edge.Set, width: CGFloat = 1) {
    self.edges = edges
    self.width = width
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()

    let halfWidth = self.width / 2

    if self.edges.contains(.top) {
      path.move(to: CGPoint(x: rect.minX, y: rect.minY + halfWidth))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + halfWidth))
    }

    if self.edges.contains(.bottom) {
      path.move(to: CGPoint(x: rect.minX, y: rect.maxY - halfWidth))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - halfWidth))
    }

    if self.edges.contains(.leading) {
      path.move(to: CGPoint(x: rect.minX + halfWidth, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.minX + halfWidth, y: rect.maxY))
    }

    if self.edges.contains(.trailing) {
      path.move(to: CGPoint(x: rect.maxX - halfWidth, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX - halfWidth, y: rect.maxY))
    }

    return path
  }
}
