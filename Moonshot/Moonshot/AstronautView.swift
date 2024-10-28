// Copyright Justin Bishop, 2024

import SwiftUI

struct AstronautView: View {
  @Binding var path: NavigationPath
  let astronaut: Astronaut
  let missions: [Mission]

  var astronautMissions: [Mission] {
    missions.filter { mission in
      mission.crew.contains { $0.name == astronaut.id }
    }
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Image(astronaut.id)
          .resizable()
          .scaledToFit()

        Text(astronaut.description)
          .padding()

        RectangleDivider()

        Text("Missions")
          .font(.title.bold())
          .padding(.horizontal)

        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(astronautMissions) { mission in
              Button {
                path = NavigationPath([mission])
              } label: {
                HStack {
                  Image(mission.image)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(.circle)
                    .overlay(
                      Circle()
                        .strokeBorder(.white, lineWidth: 1)
                    )

                  VStack(alignment: .leading) {
                    Text(mission.displayName)
                      .foregroundStyle(.white)
                      .font(.headline)
                    Text(mission.formattedLaunchDate)
                      .foregroundStyle(.white.opacity(0.5))
                  }
                }
                .padding(.horizontal)
              }
            }
          }
        }
        .padding(.horizontal)
      }
    }
    .background(.darkBackground)
    .navigationTitle(astronaut.name)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  let missions: [Mission] = Bundle.main.decode("missions.json")
  let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

  AstronautView(
    path: .constant(NavigationPath()),
    astronaut: astronauts.randomElement()!.value,
    missions: missions
  )
  .preferredColorScheme(.dark)
}
