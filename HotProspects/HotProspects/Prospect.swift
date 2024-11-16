// Copyright Justin Bishop, 2024

import Foundation
import SwiftData

@Model
class Prospect {
  @Attribute(.unique) var id = UUID()
  var name: String
  var emailAddress: String
  var isContacted: Bool

  init(name: String, emailAddress: String, isContacted: Bool = false) {
    self.name = name
    self.emailAddress = emailAddress
    self.isContacted = isContacted
  }
}
