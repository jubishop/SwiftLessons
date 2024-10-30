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
  enum CodingKeys: String, CodingKey {
    case _type = "type"
    case _quantity = "quantity"
    case _specialRequestEnabled = "specialRequestEnabled"
    case _extraFrosting = "extraFrosting"
    case _addSprinkles = "addSprinkles"
    case _name = "name"
    case _city = "city"
    case _streetAddress = "streetAddress"
    case _zip = "zip"
  }

  init() {
    loadAddress()
  }

  private var isBatchUpdating = false
  @discardableResult
  public func batchUpdate(_ updates: () throws -> Void) rethrows -> (() -> Void)? {
    isBatchUpdating = true
    defer { isBatchUpdating = false }
    try updates()
    return { [weak self] in
      self?.saveAddress()
    }
  }

  // MARK: - Order Details
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

  // MARK: - Address properties
  var name = "" {
    didSet {
      saveAddress()
    }
  }
  var streetAddress = "" {
    didSet {
      saveAddress()
    }
  }
  var city = "" {
    didSet {
      saveAddress()
    }
  }
  var zip = "" {
    didSet {
      saveAddress()
    }
  }
  var hasValidAddress: Bool {
    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedStreet = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedZip = zip.trimmingCharacters(in: .whitespacesAndNewlines)

    return !trimmedName.isEmpty && !trimmedStreet.isEmpty && !trimmedCity.isEmpty
      && !trimmedZip.isEmpty
  }

  // MARK: - Cost
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

  // MARK: - Address Persistence
  private struct AddressData: Codable {
    var name: String
    var streetAddress: String
    var city: String
    var zip: String
  }
  private func saveAddress() {
    if isBatchUpdating { return }

    let addressData = AddressData(
      name: name,
      streetAddress: streetAddress,
      city: city,
      zip: zip
    )
    print("saving address: \(addressData)")
    if let encoded = try? JSONEncoder().encode(addressData) {
      UserDefaults.standard.set(encoded, forKey: "User.address")
    }
  }
  private func loadAddress() {
    guard let data = UserDefaults.standard.data(forKey: "User.address"),
      let addressData = try? JSONDecoder().decode(AddressData.self, from: data)
    else {
      return
    }
    print("loaded address: \(addressData)")
    batchUpdate {
      name = addressData.name
      streetAddress = addressData.streetAddress
      city = addressData.city
      zip = addressData.zip
    }
  }
}
