import SwiftUI

public struct StepperTextField: View {
  @Binding var value: Int
  let width: CGFloat

  public init(value: Binding<Int>, width: CGFloat = 40) {
    self._value = value
    self.width = width
  }

  public var body: some View {
    TextField("", value: self.$value, formatter: uIntNumberFormatter)
      .multilineTextAlignment(.trailing).frame(width: width)
  }
}

// workaround for NumberFormatter bug: https://stackoverflow.com/questions/56799456/swiftui-textfield-with-formatter-not-working
extension TextField {
  public init(_ prompt: LocalizedStringKey, value: Binding<Int>, formatter: NumberFormatter)
  where Text == Label {
    self.init(
      prompt,
      text: .init(
        get: { formatter.string(for: value.wrappedValue) ?? String() },
        set: { value.wrappedValue = formatter.number(from: $0)?.intValue ?? value.wrappedValue }
      )
    )
  }
}

public class UIntNumberFormatter: NumberFormatter {
  public override init() {
    super.init()

    self.allowsFloats = false
    self.minimum = 0
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

let uIntNumberFormatter = UIntNumberFormatter()
