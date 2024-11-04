// Copyright Justin Bishop, 2024

import SwiftData
import SwiftUI

struct DetailView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  @State private var showingDeleteAlert = false

  let book: Book

  var body: some View {
    ScrollView {
      ZStack(alignment: .bottomTrailing) {
        Image(book.genre.rawValue)
          .resizable()
          .scaledToFit()

        Text(book.genre.rawValue.uppercased())
          .font(.subheadline)
          .fontWeight(.heavy)
          .padding(8)
          .foregroundStyle(.white)
          .background(.black.opacity(0.9))
          .clipShape(.capsule)
          .offset(x: -5, y: -5)
      }

      Text(book.author)
        .font(.title)
        .foregroundStyle(.secondary)

      Text(book.date.formatted(date: .long, time: .omitted))
        .font(.subheadline)

      Text(book.review)
        .padding()

      RatingView(rating: .constant(book.rating))
        .font(.largeTitle)
    }
    .navigationTitle(book.title)
    .navigationBarTitleDisplayMode(.inline)
    .scrollBounceBehavior(.basedOnSize)
    .toolbar {
      Button("Delete this book", systemImage: "trash") {
        showingDeleteAlert = true
      }
    }
    .alert("Delete book", isPresented: $showingDeleteAlert) {
      Button("Delete", role: .destructive, action: deleteBook)
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("Are you sure?")
    }
  }

  func deleteBook() {
    modelContext.delete(book)
    dismiss()
  }
}

#Preview {
  let previewContainer = DataController.previewContainer
  let books = try? previewContainer.mainContext.fetch(FetchDescriptor<Book>())
  NavigationStack {
    DetailView(book: books!.randomElement()!).modelContainer(previewContainer)
  }
}
