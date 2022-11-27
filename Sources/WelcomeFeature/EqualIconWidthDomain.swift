// for aligning SF Symbols (from https://stackoverflow.com/a/68751668/13162032)

import SwiftUI

private struct IconWidthKey: PreferenceKey {
  static var defaultValue: CGFloat? { nil }

  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    switch (value, nextValue()) {
    case (nil, let next): value = next
    case (_, nil): break
    case (.some(let current), .some(let next)): value = max(current, next)
    }
  }
}

extension IconWidthKey: EnvironmentKey {}

extension EnvironmentValues {
  fileprivate var iconWidth: CGFloat? {
    get { self[IconWidthKey.self] }
    set { self[IconWidthKey.self] = newValue }
  }
}

private struct IconWidthModifier: ViewModifier {
  @Environment(\.iconWidth) var width

  func body(content: Content) -> some View {
    content.background(
      GeometryReader { proxy in
        Color.clear.preference(key: IconWidthKey.self, value: proxy.size.width)
      }
    )
    .frame(width: width)
  }
}

struct EqualIconWidthLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.icon.modifier(IconWidthModifier())
      configuration.title
    }
  }
}

struct EqualIconWidthDomain<Content: View>: View {
  let content: Content
  @State var iconWidth: CGFloat? = nil

  init(@ViewBuilder _ content: () -> Content) { self.content = content() }

  var body: some View {
    content.environment(\.iconWidth, iconWidth)
      .onPreferenceChange(IconWidthKey.self) { self.iconWidth = $0 }
      .labelStyle(EqualIconWidthLabelStyle())
  }
}
