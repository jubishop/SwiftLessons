// Copyright Justin Bishop, 2024

import Foundation
import GRDB

@MainActor
final class CardListModel: ObservableObject {
  private let cardRepository: CardRepository

  @Published private(set) var cards: [Card] = []

  @ObservationIgnored private var cancellable: AnyDatabaseCancellable?

  init(cardRepository: CardRepository) {
    self.cardRepository = cardRepository
    let observation = ValueObservation.tracking { db in
      try Card.fetchAll(db)
    }
    cancellable = observation.start(in: cardRepository.reader) { error in
      fatalError("Failed to start tracking cards: \(error)")
    } onChange: { [unowned self] cards in
      self.cards = cards
    }
  }

  func addCard(_ card: Card) {
    performRepositoryOperation {
      try cardRepository.addCard(card)
      cards.append(card)
    }
  }

  func deleteCard(at index: Int) {
    guard index < cards.count else { return }
    let card = cards[index]
    performRepositoryOperation {
      try cardRepository.deleteCard(card)
      cards.remove(at: index)
    }
  }

  private func performRepositoryOperation(_ operation: () throws -> Void) {
    do {
      try operation()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}
