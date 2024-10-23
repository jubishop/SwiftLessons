// Copyright Justin Bishop, 2024

import Foundation

struct ExpenseItem: CustomStringConvertible, Identifiable, Codable {
  let id = UUID()
  let name: String
  let type: String
  let amount: Double

  enum CodingKeys: String, CodingKey {
    case name, type, amount
  }

  var description: String {
    "\(name) (\(type)): $\(String(format: "%.2f", amount))"
  }
}
