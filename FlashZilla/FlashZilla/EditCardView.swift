// Copyright Justin Bishop, 2024

import GRDB
import SwiftUI

struct EditCardView: View {
  @State var model: CardListModel

  init(model: CardListModel) {
    _model = State(initialValue: model)
  }

  @Environment(\.dismiss) var dismiss
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
          ForEach(0..<model.cards.count, id: \.self) { index in
            VStack(alignment: .leading) {
              Text(model.cards[index].prompt)
                .font(.headline)
              Text(model.cards[index].answer)
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
    }
  }

  func done() {
    dismiss()
  }

  func addCard() {
    let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
    let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
    guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false
    else { return }

    newPrompt.removeAll()
    newAnswer.removeAll()

    do {
      let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
      try model.addCard(card)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  func deleteCards(at offsets: IndexSet) {
    for offset in offsets {
      do {
        try model.deleteCard(at: offset)
      } catch {
        fatalError(error.localizedDescription)
      }
    }
  }
}

#Preview {
  EditCardView(model: CardListModel(appDatabase: .shared))
}
