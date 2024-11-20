// Copyright Justin Bishop, 2024

import Foundation

struct CardRepository: Sendable {
  static func empty() -> CardRepository {
    return CardRepository(.empty())
  }
  
  static let shared: CardRepository = {
    return CardRepository(.shared)
  }()

  
  private let appDatabase: AppDatabase
  
  init(_ appDatabase: AppDatabase) {
    self.appDatabase = appDatabase
  }
  
  func allCards() throws -> [Card] {
    try appDatabase.read { db in
      try Card.fetchAll(db)
    }
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
}
