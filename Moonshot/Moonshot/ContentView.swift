// Copyright Justin Bishop, 2024

import SwiftUI

struct ContentView: View {
  let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
  let missions: [Mission] = Bundle.main.decode("missions.json")
  @State private var showingGrid = true

  let columns = [
    GridItem(.adaptive(minimum: 150))
  ]

  private var listLayout: some View {
    List(missions) { mission in
      NavigationLink {
        MissionView(mission: mission, astronauts: astronauts)
      } label: {
        HStack {
          Image(mission.image)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .padding(.trailing)

          VStack(alignment: .leading) {
            Text(mission.displayName)
              .font(.headline)
            Text(mission.formattedLaunchDate)
              .font(.caption)
              .foregroundStyle(.white.opacity(0.5))
          }
        }
      }
      .listRowBackground(Color.darkBackground)
    }
    .listStyle(.plain)
  }

  private var gridLayout: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(missions) { mission in
          NavigationLink {
            MissionView(mission: mission, astronauts: astronauts)
          } label: {
            VStack {
              Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
              
              VStack {
                Text(mission.displayName)
                  .font(.headline)
                  .foregroundStyle(.white)
                Text(mission.formattedLaunchDate)
                  .font(.caption)
                  .foregroundStyle(.white.opacity(0.5))
              }
              .padding(.vertical)
              .frame(maxWidth: .infinity)
              .background(.lightBackground)
            }
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(.lightBackground)
            )
          }
        }
      }
      .padding([.horizontal, .bottom])
    }
  }

  var body: some View {
    NavigationStack {
      Group {
        if showingGrid {
          gridLayout
        } else {
          listLayout
        }
      }
      .navigationTitle("Moonshot")
      .background(.darkBackground)
      .preferredColorScheme(.dark)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            showingGrid.toggle()
          } label: {
            Image(systemName: showingGrid ? "list.bullet" : "grid")
              .foregroundStyle(.white)
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
