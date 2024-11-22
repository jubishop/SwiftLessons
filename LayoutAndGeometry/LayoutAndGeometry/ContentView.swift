// Copyright Justin Bishop, 2024

import SwiftUI

struct ContentView: View {
  let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

  var body: some View {
    GeometryReader { fullView in
      ScrollView(.vertical) {
        ForEach(0..<50) { index in
          GeometryReader { proxy in
            Text("Row #\(index)")
              .font(.title)
              .frame(maxWidth: .infinity)
              // .background(colors[index % 7])
              .background(
                Color(
                  hue: proxy.frame(in: .named("FullView")).midY
                    / fullView.size.height,
                  saturation: 1,
                  brightness: 1
                )
              )
              .rotation3DEffect(
                .degrees(
                  proxy.frame(in: .named("FullView")).midY - fullView.size
                    .height / 2
                ) / 5,
                axis: (x: 0, y: 1, z: 0)
              )
              .opacity(
                min(
                  proxy.frame(in: .named("FullView")).midY,
                  Double(400)
                ) / 400 + 0.1
              )
              .scaleEffect(
                0.5 + proxy.frame(in: .named("FullView")).midY
                  / fullView.size.height
              )

          }
          .frame(height: 40)
        }
      }
    }
    .coordinateSpace(name: "FullView")
  }
}

#Preview {
  ContentView()
}
