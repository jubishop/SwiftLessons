// Copyright Justin Bishop, 2024

import SwiftUI

enum CakeType: String, CaseIterable, Codable {
  case vanilla = "Vanilla"
  case strawberry = "Strawberry"
  case chocolate = "Chocolate"
  case rainbow = "Rainbow"

  var index: Int {
    CakeType.allCases.firstIndex(of: self)!
  }
}

@Observable
class Order: Codable {
  // Order Details
  var type: CakeType = .vanilla
  var quantity = 3
  var specialRequestEnabled = false {
    didSet {
      if specialRequestEnabled == false {
        extraFrosting = false
        addSprinkles = false
      }
    }
  }
  var extraFrosting = false
  var addSprinkles = false

  // Address
  var name = ""
  var streetAddress = ""
  var city = ""
  var zip = ""
  var hasValidAddress: Bool {
    !name.isEmpty && !streetAddress.isEmpty && !city.isEmpty && !zip.isEmpty
  }

  // Cost
  var cost: Decimal {
    // Cost for just the cake(s)
    let costPerCake: Decimal =
      switch type {
      case .vanilla: 2
      case .strawberry, .chocolate: 3
      case .rainbow: 4
      }
    var cost = Decimal(quantity) * costPerCake

    // $1/cake for extra frosting
    if extraFrosting {
      cost += Decimal(quantity)
    }

    // $0.50/cake for sprinkles
    if addSprinkles {
      cost += Decimal(quantity) / 2
    }

    return cost
  }
}
