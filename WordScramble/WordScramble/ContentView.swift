// Copyright Justin Bishop, 2024

import SwiftUI

class GameState: ObservableObject {
  @Published var allWords: [String] = []
}

struct ContentView: View {
  @StateObject private var gameState = GameState()
  @State private var usedWords: [String] = []
  @State private var rootWord = ""
  @State private var newWord = ""
  @State private var score = 0

  @FocusState private var isInputActive: Bool

  @State private var errorTitle = ""
  @State private var errorMessage = ""
  @State private var showingError = false

  private var allWords: [String] = []

  func startGame() {
    // 1. Find the URL for start.txt in our app bundle
    guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else {
      fatalError("Could not find start.txt in bundle.")
    }

    // 2. Load start.txt into a string
    guard let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) else {
      fatalError("Could not load start.txt from bundle.")
    }

    // 3. Split the string up into an array of strings
    gameState.allWords = startWords.components(separatedBy: "\n")
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }
    guard !gameState.allWords.isEmpty else {
      fatalError("start.txt is empty.")
    }

    beginNewGame()
  }

  func beginNewGame() {
    // 4. Pick one random word
    guard let randomWord = gameState.allWords.randomElement() else {
      fatalError("Could not find a random word in start.txt.")
    }
    rootWord = randomWord

    // Reset score
    score = 0

    // Clear used words
    usedWords.removeAll()

    // Clear and focus on text input
    newWord = ""
    isInputActive = true
  }

  func isLongEnough(word: String) -> Bool {
    word.count >= 3
  }

  func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
  }

  func isPossible(word: String) -> Bool {
    var tempWord = rootWord
    for letter in word {
      guard let pos = tempWord.firstIndex(of: letter) else {
        return false
      }
      tempWord.remove(at: pos)
    }
    return true
  }

  func isReal(word: String) -> Bool {
    let misspelledRange = UITextChecker()
      .rangeOfMisspelledWord(
        in: word,
        range: NSRange(location: 0, length: word.utf16.count),
        startingAt: 0,
        wrap: false,
        language: "en"
      )
    return misspelledRange.location == NSNotFound
  }

  func addNewWord() {
    // Focus on text field
    isInputActive = true

    // lowercase and trim the word, to make sure we don't add duplicate words with case differences
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

    // exit if the remaining string is empty
    guard !answer.isEmpty else { return }

    guard isLongEnough(word: answer) else {
      wordError(
        title: "Word too short",
        message: "Word has to be 3 or more characters"
      )
      return
    }

    guard isOriginal(word: answer) else {
      wordError(
        title: "Word used already",
        message: "Be more original"
      )
      return
    }

    guard isPossible(word: answer) else {
      wordError(
        title: "Word not possible",
        message: "You can't spell that word from '\(rootWord)'!"
      )
      return
    }

    guard isReal(word: answer) else {
      wordError(
        title: "Word not recognized",
        message: "You can't just make them up, you know!"
      )
      return
    }

    // Update score and insert answer into our list
    score += answer.count
    withAnimation {
      usedWords.insert(answer, at: 0)
    }

    // Clear text input
    newWord = ""
  }

  func wordError(title: String, message: String) {
    errorTitle = title
    errorMessage = message
    showingError = true
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          TextField("Enter your word", text: $newWord)
            .onSubmit(addNewWord)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .keyboardType(.alphabet)
            .focused($isInputActive)
        }

        Section {
          Text("Total Score: \(score)")
        }

        Section {
          ForEach(usedWords, id: \.self) { word in
            HStack {
              Image(systemName: "\(word.count).circle")
              Text(word)
            }
          }
        }
      }
      .navigationTitle(rootWord)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("New Game") {
            beginNewGame()
          }
        }
      }
    }
    .onAppear(perform: startGame)
    .alert(errorTitle, isPresented: $showingError) {
    } message: {
      Text(errorMessage)
    }
  }
}

#Preview {
  ContentView()
}
