extension Bundle {
  public static var current: Bundle {
    class __ {}
    return Bundle(for: __.self)
  }
}

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
