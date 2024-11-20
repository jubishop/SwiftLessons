// Copyright Justin Bishop, 2024 

import Foundation

@MainActor final class CardListModel : ObservableObject {
  private let appDatabase: AppDatabase

  @Published private(set) var cards: [Card] = []
  
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
