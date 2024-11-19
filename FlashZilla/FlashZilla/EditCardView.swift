// Copyright Justin Bishop, 2024

import GRDB
import SwiftUI

struct EditCardView: View {
  let dbQueue: DatabaseQueue

  init() {
    do {
      dbQueue = try DatabaseQueue(
        path: URL.documentsDirectory
          .appending(path: "db.sqlite")
          .absoluteString
      )
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  @Environment(\.dismiss) var dismiss
  @State private var cards: [Card] = []
  @State private var newPrompt = ""
  @State private var newAnswer = ""

  var body: some View {
    NavigationStack {
      List {
        Section("Add new card") {
          TextField("Prompt", text: $newPrompt)
          TextField("Answer", text: $newAnswer)
          Button("Add Card", action: addCard)
        }

        Section {
          ForEach(0..<cards.count, id: \.self) { index in
            VStack(alignment: .leading) {
              Text(cards[index].prompt)
                .font(.headline)
              Text(cards[index].answer)
                .foregroundStyle(.secondary)
            }
          }
          .onDelete(perform: deleteCards)
        }
      }
      .navigationTitle("Edit Cards")
      .toolbar {
        Button("Done", action: done)
      }
      .onAppear(perform: loadData)
    }
  }

  func done() {
    dismiss()
  }

  func loadData() {
    do {
      cards = try dbQueue.read { db in
        try Card.fetchAll(db)
      }
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  private func performWrite(_ block: @escaping (Database) throws -> Void) {
    do {
      try dbQueue.write(block)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func addCard() {
    let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
    let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
    guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false
    else { return }

    newPrompt.removeAll()
    newAnswer.removeAll()

    var card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
    cards.insert(card, at: 0)
    performWrite { db in
      try card.insert(db)
    }
  }

  func deleteCards(at offsets: IndexSet) {
    for offset in offsets {
      let card = cards[offset]
      cards.remove(at: offset)
      performWrite { db in
        try card.delete(db)
      }
    }
  }
}

#Preview {
  EditCardView()
}
