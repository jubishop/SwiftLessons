// Copyright Justin Bishop, 2024

import Foundation

@MainActor
final class CardListModel: ObservableObject {
  private let cardRepository: CardRepository

  @Published private(set) var cards: [Card] = []

  init(cardRepository: CardRepository) {
    self.cardRepository = cardRepository
    performRepositoryOperation {
      cards = try cardRepository.allCards()
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
