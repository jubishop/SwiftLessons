// Copyright Justin Bishop, 2024

import SwiftUI

struct MissionView: View {
  struct CrewMember {
    let role: String
    let astronaut: Astronaut
  }

  @Binding var path: NavigationPath
  let crew: [CrewMember]
  let mission: Mission
  let missions: [Mission]

  init(
    path: Binding<NavigationPath>,
    mission: Mission,
    missions: [Mission],
    astronauts: [String: Astronaut]
  ) {
    self.mission = mission
    self.missions = missions
    self.crew = mission.crew.map { member in
      if let astronaut = astronauts[member.name] {
        return CrewMember(role: member.role, astronaut: astronaut)
      } else {
        fatalError("Missing \(member.name)")
      }
    }
    self._path = path
  }

  var body: some View {
    ScrollView {
      VStack {
        Image(mission.image)
          .resizable()
          .scaledToFit()
          .containerRelativeFrame(.horizontal) { width, axis in
            width * 0.75
          }
          .padding([.top, .bottom])

        Text(mission.formattedLaunchDate)
          .foregroundStyle(.white.opacity(0.5))

        VStack(alignment: .leading) {
          RectangleDivider()

          Text("Mission Highlights")
            .font(.title.bold())
            .padding(.bottom, 5)

          Text(mission.description)

          RectangleDivider()

          Text("Crew")
            .font(.title.bold())
            .padding(.bottom, 5)
        }
        .padding(.horizontal)

        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(crew, id: \.role) { crewMember in
              NavigationLink(
                value: crewMember.astronaut,
                label: {
                  HStack {
                    Image(crewMember.astronaut.id)
                      .resizable()
                      .frame(width: 104, height: 72)
                      .clipShape(.capsule)
                      .overlay(
                        Capsule()
                          .strokeBorder(.white, lineWidth: 1)
                      )

                    VStack(alignment: .leading) {
                      Text(crewMember.astronaut.name)
                        .foregroundStyle(.white)
                        .font(.headline)
                      Text(crewMember.role)
                        .foregroundStyle(.white.opacity(0.5))
                    }
                  }
                  .padding(.horizontal)
                }
              )
            }
          }
          .navigationDestination(for: Astronaut.self) { astronaut in
            AstronautView(
              path: $path,
              astronaut: astronaut,
              missions: missions
            )
          }
        }
      }
      .padding(.bottom)
    }
    .navigationTitle(mission.displayName)
    .navigationBarTitleDisplayMode(.inline)
    .background(.darkBackground)
  }
}

#Preview {
  let missions: [Mission] = Bundle.main.decode("missions.json")
  let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

  NavigationStack {
    MissionView(
      path: .constant(NavigationPath()),
      mission: missions.randomElement()!,
      missions: missions,
      astronauts: astronauts
    )
    .preferredColorScheme(.dark)
  }
}
