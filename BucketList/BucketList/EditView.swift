// Copyright Justin Bishop, 2024

import SwiftUI

struct EditView: View {
  @Environment(\.dismiss) var dismiss

  @State private var viewModel: ViewModel

  init(location: Location, onSave: @escaping (Location) -> Void) {
    _viewModel = State(initialValue: ViewModel(location: location, onSave: onSave))
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("Place name", text: $viewModel.name)
          TextField("Description", text: $viewModel.description)
        }

        Section("Nearby…") {
          switch viewModel.loadingState {
          case .loaded:
              ForEach(viewModel.pages, id: \.pageid) { page in
              Button(action: {
                viewModel.name = page.title
                viewModel.description = page.description
              }) {
                Text(page.title)
                  .font(.headline)
                  + Text(": ")
                  + Text(page.description)
                  .italic()
              }
            }
          case .loading:
            Text("Loading…")
          case .failed:
            Text("Please try again later.")
          }
        }
      }
      .navigationTitle("Place details")
      .toolbar {
        Button("Save") {
          viewModel.saveLocation()
          dismiss()
        }
      }
      .task {
        await viewModel.fetchNearbyPlaces()
      }
    }
  }
}

#Preview {
  EditView(location: .example) { _ in }
}
