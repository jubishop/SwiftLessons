// Copyright Justin Bishop, 2024

import Foundation
import SwiftData

@Model
class Expense {
  static let types = ["Business", "Personal"]

  var name: String
  var type: String
  var amount: Double
  
  init(name: String, type: String, amount: Double) {
    self.name = name
    self.type = type
    self.amount = amount
  }
}
