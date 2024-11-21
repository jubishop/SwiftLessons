// Copyright Justin Bishop, 2024

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(alignment: .leading) {
      ForEach(0..<10) { position in
        Text(String(repeating: "Num", count: position))
          .alignmentGuide(.leading) { context in
            context.width
          }
      }
    }
    .background(.red)
    .frame(width: 400, height: 400)
    .background(.blue)
  }
}

#Preview {
  ContentView()
}
