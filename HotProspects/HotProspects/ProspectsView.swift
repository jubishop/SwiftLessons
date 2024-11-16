// Copyright Justin Bishop, 2024

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

enum FilterType {
  case none, contacted, uncontacted
}

enum SortType {
  case name, dateAdded
}

struct ProspectsView: View {
  let filter: FilterType

  @Environment(\.modelContext) var modelContext
  @State private var sortType = SortType.name
  @State private var selectedProspects = Set<Prospect>()
  @State private var isShowingScanner = false
  @State private var editMode: EditMode = .inactive

  var title: String {
    switch filter {
    case .none:
      "Everyone"
    case .contacted:
      "Contacted people"
    case .uncontacted:
      "Uncontacted people"
    }
  }

  var body: some View {
    NavigationStack {
      ProspectsListView(
        filter: filter,
        sortType: sortType,
        selectedProspects: $selectedProspects,
        editMode: $editMode
      )

      .navigationTitle(title)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Picker("Sort", selection: $sortType) {
              Label("Sort by Name", systemImage: "textformat").tag(SortType.name)
              Label("Sort by Date Added", systemImage: "calendar").tag(SortType.dateAdded)
            }
          } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button("Scan", systemImage: "qrcode.viewfinder") {
            isShowingScanner = true
          }
        }

        ToolbarItem(placement: .topBarLeading) {
          Button("Edit") {
            editMode = .active
          }
        }

        if selectedProspects.isEmpty == false {
          ToolbarItem(placement: .bottomBar) {
            Button("Delete Selected", action: delete)
          }
        }
      }
      .sheet(isPresented: $isShowingScanner) {
        CodeScannerView(
          codeTypes: [.qr],
          simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
          completion: handleScan
        )
      }
    }
  }


  func delete() {
    for prospect in selectedProspects {
      modelContext.delete(prospect)
    }
  }

  func handleScan(result: Result<ScanResult, ScanError>) {
    isShowingScanner = false
    switch result {
    case .success(let result):
      let details = result.string.components(separatedBy: "\n")
      guard details.count == 2 else { return }

      let person = Prospect(
        name: details[0],
        emailAddress: details[1],
        isContacted: false
      )
      modelContext.insert(person)
    case .failure(let error):
      print("Scanning failed: \(error.localizedDescription)")
    }
  }
}

#Preview {
  ProspectsView(filter: .none).modelContainer(DataController.previewContainer)
}
