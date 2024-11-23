// Copyright Justin Bishop, 2024

import SwiftUI

@Observable
class Player {
  var name = "Anonymous"
  var highScore = 0
}

struct HighScoreView: View {
  @Environment(Player.self) var player
  
  var body: some View {
    HighScoreInternalView(player: player)
  }
}

struct HighScoreInternalView : View {
  @Bindable var player : Player
  
  init(player : Player) {
    self.player = player
  }
  
  var body: some View {
    Stepper("High score: \(player.highScore)", value: $player.highScore)
  }
}

struct ContentView: View {
  @State private var player = Player()

  var body: some View {
    VStack {
      Text("Welcome!")
      HighScoreView()
    }
    .environment(player)
  }
}

#Preview {
  ContentView()
}
