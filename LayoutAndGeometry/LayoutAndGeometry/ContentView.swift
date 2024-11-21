// Copyright Justin Bishop, 2024

import SwiftUI

struct ContentView: View {
  let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

  var body: some View {
    ScrollView {
      ForEach(0..<50) { index in
        GeometryReader { proxy in
          Text("Row #\(index)")
            .font(.title)
            .frame(maxWidth: .infinity)
            .background(colors[index % 7])
            .rotation3DEffect(
              .degrees(
                proxy.frame(in: .global).minY / 5
              ),
              axis: (x: 0, y: 1, z: 0)
            )
        }
        .frame(height: 40)
      }
    }
  }
}

#Preview {
  ContentView()
}
