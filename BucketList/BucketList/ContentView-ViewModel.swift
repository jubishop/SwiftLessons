// Copyright Justin Bishop, 2024

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
  @Observable
  class ViewModel {
    var isUnlocked = false
    var selectedPlace: Location?

    private(set) var locations: [Location] {
      didSet {
        save()
      }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")

    init() {
      do {
        let data = try Data(contentsOf: savePath)
        locations = try JSONDecoder().decode([Location].self, from: data)
      } catch {
        locations = []
      }

      #if DEBUG
        if ProcessInfo.isRunningInPreview {
          isUnlocked = true
        }
      #endif
    }

    func authenticate(_ context: LAContext, onFailure: @escaping (Error?) -> Void) {
      var error: NSError?

      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Please authenticate yourself to unlock your places."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
          success,
          authenticationError in

          if success {
            self.isUnlocked = true
          } else {
            onFailure(authenticationError)
          }
        }
      } else {
        onFailure(error)
      }
    }

    func save() {
      try? JSONEncoder().encode(locations)
        .write(to: savePath, options: [.atomic, .completeFileProtection])
    }

    func update(location: Location) {
      guard let selectedPlace else { return }

      if let index = locations.firstIndex(of: selectedPlace) {
        locations[index] = location
      }
    }

    func addLocation(at point: CLLocationCoordinate2D) {
      let newLocation = Location(
        name: "New location",
        description: "",
        point: point
      )
      locations.append(newLocation)
    }
  }
}
