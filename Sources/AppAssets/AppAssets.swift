import AppKit

public struct AppAssets { public static let bundle = Bundle.module }

extension NSImage {
  // same initializer as UIImage
  public convenience init?(named name: String, in bundle: Bundle?) {
    guard let imageData = bundle?.image(forResource: name)?.tiffRepresentation else { return nil }

    self.init(data: imageData)
  }
}
