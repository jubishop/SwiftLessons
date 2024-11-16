// Copyright Justin Bishop, 2024

import Foundation
import SwiftData

@Model
class Prospect {
  @Attribute(.unique) var id = UUID()
  var name: String
  var emailAddress: String
  var isContacted: Bool
  var dateAdded: Date

  init(name: String, emailAddress: String, isContacted: Bool = false, dateAdded: Date = .now) {
    self.name = name
    self.emailAddress = emailAddress
    self.isContacted = isContacted
    self.dateAdded = dateAdded
  }
}
