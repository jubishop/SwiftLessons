// Copyright Justin Bishop, 2024

import Foundation

extension ProcessInfo {
  static var isRunningInPreview: Bool {
#if DEBUG
    return processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
    return false
#endif
  }
}
