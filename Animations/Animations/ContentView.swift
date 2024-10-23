// Copyright Justin Bishop, 2024

import SwiftUI

struct PivotModifier: ViewModifier {
  let isShowing: Bool

  func body(content: Content) -> some View {
    content
      .rotation3DEffect(
        .degrees(isShowing ? 0 : -90),
        axis: (x: 0, y: 0, z: 1),
        anchor: .topLeading
      )
      .clipped()
  }
}

extension View {
  func pivot(isShowing: Bool) -> some View {
    self.modifier(PivotModifier(isShowing: isShowing))
  }
}

struct ContentView: View {
  @State private var showingPages = [false, false]

  var body: some View {
    ZStack {
      Rectangle()
        .fill(.blue)
        .frame(width: 200, height: 200)

      Rectangle()
        .fill(.red)
        .frame(width: 200, height: 200)
        .pivot(isShowing: showingPages[0])

      Rectangle()
        .fill(.orange)
        .frame(width: 200, height: 200)
        .pivot(isShowing: showingPages[1])
    }
    .onTapGesture {
      withAnimation {
        for pageNumber in 0..<showingPages.count where !showingPages[pageNumber] {
          showingPages[pageNumber].toggle()
          break
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
