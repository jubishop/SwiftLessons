// Copyright Justin Bishop, 2024

import SwiftData

@MainActor
class DataController {
  static let previewContainer: ModelContainer = {
    do {
      let container = try ModelContainer(
        for: Book.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      )

      for i in 1...9 {
        let book = Book(
          title: "Title \(i)",
          author: "Author \(i)",
          genre: Book.Genre.allCases.randomElement()!,
          review: "It was ok for a book",
          rating: Int.random(in: 1...5)
        )
        container.mainContext.insert(book)
      }

      return container
    } catch {
      fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
  }()
}
