// Copyright Justin Bishop, 2024

import SwiftUI

struct AstronautView: View {
  @Binding var path: NavigationPath
  let astronaut: Astronaut

  var body: some View {
    ScrollView {
      VStack {
        Image(astronaut.id)
          .resizable()
          .scaledToFit()

        Text(astronaut.description)
          .padding()
      }
    }
    .background(.darkBackground)
    .navigationTitle(astronaut.name)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

  AstronautView(
    path: .constant(NavigationPath()),
    astronaut: astronauts.randomElement()!.value
  )
  .preferredColorScheme(.dark)
}
