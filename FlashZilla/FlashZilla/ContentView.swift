// Copyright Justin Bishop, 2024

import GRDB
import SwiftUI

extension View {
  func stacked(at position: Int, in total: Int) -> some View {
    let offset = Double(total - position)
    return self.offset(y: offset * 10)
  }
}

struct ContentView: View {
  @Environment(\.accessibilityDifferentiateWithoutColor)
  var accessibilityDifferentiateWithoutColor
  @Environment(\.accessibilityVoiceOverEnabled)
  var accessibilityVoiceOverEnabled
  @Environment(\.scenePhase) var scenePhase

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  @State private var isActive = true
  @State private var timeRemaining = 100
  @State private var cards: [Card] = []
  @State private var showingEditScreen = false

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

  var body: some View {
    ZStack {
      Image(decorative: "background")
        .resizable()
        .ignoresSafeArea()
      VStack {
        Text("Time: \(timeRemaining)")
          .font(.largeTitle)
          .foregroundStyle(.white)
          .padding(.horizontal, 20)
          .padding(.vertical, 5)
          .background(.black.opacity(0.75))
          .clipShape(.capsule)
        ZStack {
          ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
            CardView(card: card) { correct in
              if correct {
                removeCard(card)
              } else {
                moveCardToBack(card)
              }
            }
            .stacked(at: index, in: cards.count)
            .allowsHitTesting(index == cards.count - 1)
            .accessibilityHidden(index < cards.count - 1)
          }
        }
        .allowsHitTesting(timeRemaining > 0)

        if cards.isEmpty {
          Button("Start Again", action: resetCards)
            .padding()
            .background(.white)
            .foregroundStyle(.black)
            .clipShape(.capsule)
        }
      }
      VStack {
        HStack {
          Spacer()

          Button {
            showingEditScreen = true
          } label: {
            Image(systemName: "plus.circle")
              .padding()
              .background(.black.opacity(0.7))
              .clipShape(.circle)
          }
        }

        Spacer()
      }
      .foregroundStyle(.white)
      .font(.largeTitle)
      .padding()
      if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled
      {
        VStack {
          Spacer()

          HStack {
            Button {
              if !cards.isEmpty {
                moveCardToBack(cards.last!)
              }
            } label: {
              Image(systemName: "xmark.circle")
                .padding()
                .background(.black.opacity(0.7))
                .clipShape(.circle)
            }
            .accessibilityLabel("Wrong")
            .accessibilityHint("Mark your answer as being incorrect.")

            Spacer()

            Button {
              if !cards.isEmpty {
                removeCard(cards.last!)
              }
            } label: {
              Image(systemName: "checkmark.circle")
                .padding()
                .background(.black.opacity(0.7))
                .clipShape(.circle)
            }
            .accessibilityLabel("Correct")
            .accessibilityHint("Mark your answer as being correct.")
          }
          .foregroundStyle(.white)
          .font(.largeTitle)
          .padding()
        }
      }
    }
    .onReceive(timer) { time in
      guard isActive else { return }

      if timeRemaining > 0 {
        timeRemaining -= 1
      }
    }
    .onChange(of: scenePhase) {
      if scenePhase == .active && !cards.isEmpty {
        isActive = true
      } else {
        isActive = false
      }
    }
    .sheet(
      isPresented: $showingEditScreen,
      onDismiss: resetCards,
      content: EditCardView.init
    )
    .onAppear(perform: resetCards)
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

  func resetCards() {
    timeRemaining = 100
    isActive = true
    loadData()
  }

  func removeCard(_ card: Card) {
    guard !cards.isEmpty else { return }

    withAnimation {
      if let index = cards.firstIndex(where: { $0.id == card.id }) {
        cards.remove(at: index)
      }
    }

    if cards.isEmpty {
      isActive = false
    }
  }

  func moveCardToBack(_ card: Card) {
    guard let index = cards.firstIndex(where: { $0.id == card.id }) else {
      return
    }

    withAnimation {
      cards.remove(at: index)
      cards.insert(Card(prompt: card.prompt, answer: card.answer), at: 0)
    }
  }
}

#Preview {
  ContentView()
}
