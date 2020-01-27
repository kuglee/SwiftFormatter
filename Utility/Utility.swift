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
