// Copyright Justin Bishop, 2024

import Foundation
import MapKit
import SwiftUI

enum CustomMapStyle: String, CaseIterable, Identifiable {
  case standard
  case hybrid
  case satellite

  var id: String { self.rawValue }

  var mapStyle: MapStyle {
    switch self {
    case .standard:
      return .standard
    case .hybrid:
      return .hybrid
    case .satellite:
      return .imagery
    }
  }
}
