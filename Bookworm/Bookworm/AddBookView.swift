// Copyright Justin Bishop, 2024

import SwiftUI

struct AddBookView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss

  @State private var title = ""
  @State private var author = ""
  @State private var rating = 3
  @State private var genre = Book.Genre.fantasy
  @State private var review = ""
  @State private var date = Date.now

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Name of book", text: $title)
          TextField("Author's name", text: $author)
          DatePicker("Date", selection: $date, displayedComponents: .date)
          Picker("Genre", selection: $genre) {
            ForEach(Book.Genre.allCases) { genre in
              Text(genre.rawValue)
            }
          }
        }

        Section("Write a review") {
          TextEditor(text: $review)
          RatingView(rating: $rating)
        }

        Section {
          Button("Save") {
            let newBook = Book(
              title: title,
              author: author,
              genre: genre,
              review: review,
              rating: rating,
              date: date
            )
            modelContext.insert(newBook)
            dismiss()
          }
        }
        .disabled(title.isEmpty || author.isEmpty)
      }
      .navigationTitle("Add Book")
    }
  }
}

#Preview {
  AddBookView()
}
