import Defaults
import Foundation
import SwiftFormatConfiguration
import os.log

let extensionDefaults = UserDefaults(suiteName: "group.com.kuglee.SwiftFormatter")!

extension Defaults.Keys {
  public static let didRunBefore = Key<Bool>(
    "didRunBefore",
    default: false,
    suite: extensionDefaults
  )
  public static let configuration = Key<Configuration>(
    "configuration",
    default: Configuration(),
    suite: extensionDefaults
  )
  public static let shouldTrimTrailingWhitespace = Key<Bool>(
    "shouldTrimTrailingWhitespace",
    default: false,
    suite: extensionDefaults
  )
}

extension Configuration: Defaults.Serializable {}
