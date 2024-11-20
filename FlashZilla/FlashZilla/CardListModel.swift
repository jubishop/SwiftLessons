// Copyright Justin Bishop, 2024 

import Foundation

@Observable @MainActor final class CardListModel {
  private let appDatabase: AppDatabase

  private(set) var cards: [Card] = []
  
  init(appDatabase: AppDatabase) {
    self.appDatabase = appDatabase
    do {
      cards = try appDatabase.read { db in
        try Card.fetchAll(db)
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  func addCard(_ card: Card) throws {
    cards.append(card)
    try appDatabase.write { db in
      try card.insert(db)
    }
  }
  
  func deleteCard(at: Int) throws {
    let card = cards[at]
    cards.remove(at: at)
    try appDatabase.write { db in
      try card.delete(db)
    }
  }
}
