import SwiftUI

public class UIntNumberFormatter: NumberFormatter {
  public override init() {
    super.init()

    self.allowsFloats = false
    self.minimum = 0
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension Collection {
  public func enumeratedArray() -> [(offset: Int, element: Self.Element)] {
    return Array(self.enumerated())
  }
}

extension View {
  public func toolTip(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle? = nil,
    comment: String? = nil
  ) -> some View {
    let localizedString = NSLocalizedString(
      key,
      tableName: tableName,
      bundle: bundle ?? Bundle(),
      comment: comment ?? ""
    )

    return self.background(TooltipView(toolTip: localizedString))
  }
}

private struct TooltipView: NSViewRepresentable {
  let toolTip: String

  func makeNSView(context: NSViewRepresentableContext<TooltipView>) -> NSView {
    NSView()
  }

  func updateNSView(
    _ nsView: NSView,
    context: NSViewRepresentableContext<TooltipView>
  ) { nsView.toolTip = self.toolTip }
}

extension Bundle {
  public var displayName: String {
    let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
  }
}
