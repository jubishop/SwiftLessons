// Copyright Justin Bishop, 2024

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
  static func == (lhs: Location, rhs: Location) -> Bool {
    lhs.id == rhs.id
  }

  var id = UUID()
  var name: String
  var description: String
  var latitude: Double
  var longitude: Double

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  init(
    name: String,
    description: String,
    point: CLLocationCoordinate2D
  ) {
    self.name = name
    self.description = description
    self.latitude = point.latitude
    self.longitude = point.longitude
  }

  #if DEBUG
    static let example = Location(
      name: "Buckingham Palace",
      description: "Lit by over 40,000 lightbulbs.",
      point: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)
    )
  #endif
}
