// Copyright Justin Bishop, 2024

import Foundation
import GRDB

struct CardRepository: Sendable {
  static func empty() -> CardRepository {
    CardRepository(.empty())
  }

  static let shared: CardRepository = {
    CardRepository(.shared)
  }()

  private let appDatabase: AppDatabase

  init(_ appDatabase: AppDatabase) {
    self.appDatabase = appDatabase
  }

  func addCard(_ card: Card) throws {
    try appDatabase.write { db in
      try card.insert(db)
    }
  }

  func deleteCard(_ card: Card) throws {
    try appDatabase.write { db in
      try card.delete(db)
    }
  }

  var reader: any GRDB.DatabaseReader {
    appDatabase.reader
  }
}
