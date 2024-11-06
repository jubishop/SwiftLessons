// Copyright Justin Bishop, 2024

import Foundation
import SwiftData

@Model
class Expense {
  enum ExpenseType: String, Codable, CaseIterable {
    case business = "Business"
    case personal = "Personal"
  }
  
  var name: String
  var typeRawValue: String // ExpenseType
  var amount: Double
  
  var type: ExpenseType {
    get { ExpenseType(rawValue: typeRawValue)! }
    set { typeRawValue = newValue.rawValue }
  }
  
  init(name: String, type: ExpenseType, amount: Double) {
    self.name = name
    self.typeRawValue = type.rawValue
    self.amount = amount
  }
}
