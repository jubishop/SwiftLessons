// Copyright Justin Bishop, 2024

import SwiftUI

struct ContentView: View {
  enum SortOrder: String, CaseIterable, Identifiable {
    case standard = "Default"
    case alphabetically = "Alphabetical"
    case byCountry = "Country"

    var id: String { self.rawValue }
  }

  let resorts: [Resort] = Resort.allResorts

  var filteredResorts: [Resort] {
    var filtered =
      searchText.isEmpty
      ? resorts
      : resorts.filter { resort in
        resort.name.localizedStandardContains(searchText)
      }

    switch sortOrder {
    case .standard:
      break
    case .alphabetically:
      filtered.sort { $0.name < $1.name }
    case .byCountry:
      filtered.sort { $0.country < $1.country }
    }

    return filtered
  }

  @State private var favorites = Favorites()
  @State private var searchText = ""
  @State private var sortOrder: SortOrder = .standard

  var body: some View {
    NavigationSplitView(
      sidebar: {
        List(filteredResorts) { resort in
          NavigationLink(value: resort) {
            HStack {
              Image(resort.country)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 25)
                .clipShape(.rect(cornerRadius: 5))
                .overlay(
                  RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
                )

              VStack(alignment: .leading) {
                Text(resort.name)
                  .font(.headline)
                Text("\(resort.runs) runs")
                  .foregroundStyle(.secondary)
              }

              if favorites.contains(resort) {
                Spacer()
                Image(systemName: "heart.fill")
                  .accessibilityLabel("This is a favorite resort")
                  .foregroundStyle(.red)
              }
            }
          }
        }
        .navigationTitle("Resorts")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Picker("Sort Order", selection: $sortOrder) {
              ForEach(SortOrder.allCases) { order in
                Text(order.rawValue).tag(order)
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
        }
        .navigationDestination(for: Resort.self) { resort in
          ResortView(resort: resort)
        }
        .searchable(text: $searchText, prompt: "Search for a resort")
        .animation(.easeInOut, value: sortOrder)
      },
      detail: {
        WelcomeView()
      }
    )
    .environment(favorites)
  }
}

#Preview {
  ContentView()
}
