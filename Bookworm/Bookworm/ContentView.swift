// Copyright Justin Bishop, 2024

import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) var modelContext
  @Query(sort: [
    SortDescriptor(\Book.rating, order: .reverse),
    SortDescriptor(\Book.title),
    SortDescriptor(\Book.author),
  ]) var books: [Book]
  @State private var showingAddScreen = false

  var body: some View {
    NavigationStack {
      List {
        ForEach(books) { book in
          NavigationLink(value: book) {
            HStack {
              EmojiRatingView(rating: book.rating)
                .font(.largeTitle)

              VStack(alignment: .leading) {
                Text(book.title)
                  .font(.headline)
                Text(book.author)
                  .foregroundStyle(.secondary)
              }

              Spacer()

              if book.rating == 1 {
                Image(systemName: "hand.thumbsdown.fill")
                  .foregroundColor(.red)
              }
            }
          }
        }
        .onDelete(perform: deleteBooks)
      }
      .scrollBounceBehavior(.basedOnSize)
      .navigationTitle("Bookworm")
      .navigationDestination(for: Book.self) { book in
        DetailView(book: book)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button("Add Book", systemImage: "plus") {
            showingAddScreen.toggle()
          }
        }
      }
      .sheet(isPresented: $showingAddScreen) {
        AddBookView()
      }
    }
  }

  func deleteBooks(at offsets: IndexSet) {
    for offset in offsets {
      modelContext.delete(books[offset])
    }
  }
}

#Preview {
  ContentView().modelContainer(DataController.previewContainer)
}
