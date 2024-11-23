// Copyright Justin Bishop, 2024

import Foundation

struct Resort: Codable, Hashable, Identifiable {
  static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
  static let example = allResorts[0]

  var facilityTypes: [Facility] {
    facilities.map(Facility.init)
  }

  var id: String
  var name: String
  var country: String
  var description: String
  var imageCredit: String
  var price: Int
  var size: Int
  var snowDepth: Int
  var elevation: Int
  var runs: Int
  var facilities: [String]
}
