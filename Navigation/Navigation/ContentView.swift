// Copyright Justin Bishop, 2024

import SwiftUI

@Observable
class PathStore {
  var path: NavigationPath {
    didSet {
      save()
    }
  }

  private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

  init() {
    if let data = try? Data(contentsOf: savePath) {
      if let decoded = try? JSONDecoder()
        .decode(NavigationPath.CodableRepresentation.self, from: data)
      {
        path = NavigationPath(decoded)
        return
      }
    }

    // Still here? Start with an empty path.
    path = NavigationPath()
  }

  func save() {
    guard let representation = path.codable else {
      fatalError("Not all paths are codable?!")
    }

    do {
      let data = try JSONEncoder().encode(representation)
      try data.write(to: savePath)
    } catch {
      fatalError("Failed to save navigation data")
    }
  }
}

struct DetailView: View {
  var number: Int

  var body: some View {
    NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
      .navigationTitle("Number: \(number)")
      .navigationBarTitleDisplayMode(.inline)
  }
}

struct ContentView: View {
  @State private var title = "SwiftUI"

  var body: some View {
    NavigationStack {
      Text("Hello, world!")
        .navigationTitle($title)
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  ContentView()
}
