// Copyright Justin Bishop, 2024

import Foundation

extension EditView {
  @Observable
  class ViewModel {
    enum LoadingState {
      case loading, loaded, failed
    }

    var pages: [Page] = []
    var loadingState = LoadingState.loading

    var name: String {
      get {
        location.name
      }
      set(newName) {
        location.name = newName
      }
    }

    var description: String {
      get {
        location.description
      }
      set(newDescription) {
        location.description = newDescription
      }
    }

    private(set) var location: Location
    private var onSave: (Location) -> Void

    init(location: Location, onSave: @escaping (Location) -> Void) {
      self.location = location
      self.onSave = onSave
    }

    func saveLocation() {
      onSave(Location(name: name, description: description, point: location.coordinate))
    }

    func fetchNearbyPlaces() async {
      let urlString =
        "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

      guard let url = URL(string: urlString) else {
        loadingState = .failed
        return
      }

      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let items = try JSONDecoder().decode(Result.self, from: data)
        pages = items.query.pages.values.sorted()
        loadingState = .loaded
      } catch {
        loadingState = .failed
      }
    }
  }
}
