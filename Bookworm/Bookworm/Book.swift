// Copyright Justin Bishop, 2024

import SwiftData
import SwiftUI

@Model
class Book {
  enum Genre: String, Codable, CaseIterable, Identifiable {
    case fantasy = "Fantasy"
    case horror = "Horror"
    case kids = "Kids"
    case mystery = "Mystery"
    case poetry = "Poetry"
    case romance = "Romance"
    case thriller = "Thriller"

    var id: Self { self }
  }

  var title: String
  var author: String
  var genre: Genre
  var review: String
  var rating: Int
  var date: Date

  init(
    title: String,
    author: String,
    genre: Genre,
    review: String,
    rating: Int,
    date: Date = .now
  ) {
    self.title = title
    self.author = author
    self.genre = genre
    self.review = review
    self.rating = rating
    self.date = date
  }
}
