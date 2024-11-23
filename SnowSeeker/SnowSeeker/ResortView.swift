// Copyright Justin Bishop, 2024

import SwiftUI

struct ResortView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.dynamicTypeSize) var dynamicTypeSize
  @Environment(Favorites.self) var favorites

  let resort: Resort

  @State private var selectedFacility: Facility?
  @State private var showingFacility = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        ZStack {
          Image(decorative: resort.id)
            .resizable()
            .scaledToFit()
          
          VStack {
            Spacer()
            HStack {
              Spacer()
              Text(resort.imageCredit)
                .font(.caption)
                .padding(5)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding([.bottom, .trailing], 8)
                .dynamicTypeSize(...DynamicTypeSize.xxLarge)
            }
          }
        }

        HStack {
          if horizontalSizeClass == .compact && dynamicTypeSize > .large {
            VStack(spacing: 10) { ResortDetailsView(resort: resort) }
            VStack(spacing: 10) { SkiDetailsView(resort: resort) }
          } else {
            ResortDetailsView(resort: resort)
            SkiDetailsView(resort: resort)
          }
        }
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
        .padding(.vertical)
        .background(.primary.opacity(0.1))

        Group {
          Text(resort.description)
            .padding(.vertical)

          Text("Facilities")
            .font(.headline)

          HStack {
            ForEach(resort.facilityTypes) { facility in
              Button(
                action: {
                  selectedFacility = facility
                  showingFacility = true
                },
                label: {
                  facility.icon
                    .font(.title)
                }
              )
            }
          }
          .padding(.vertical)
        }
        .padding(.horizontal)
      }

      Button(
        favorites.contains(resort)
          ? "Remove from Favorites" : "Add to Favorites"
      ) {
        if favorites.contains(resort) {
          favorites.remove(resort)
        } else {
          favorites.add(resort)
        }
      }
      .buttonStyle(.borderedProminent)
      .padding()
    }
    .navigationTitle("\(resort.name), \(resort.country)")
    .navigationBarTitleDisplayMode(.inline)
    .alert(
      selectedFacility?.name ?? "More information",
      isPresented: $showingFacility,
      presenting: selectedFacility,
      actions: { _ in
      },
      message: { facility in
        Text(facility.description)
      }
    )
  }
}

#Preview {
  ResortView(resort: .example).environment(Favorites())
}
