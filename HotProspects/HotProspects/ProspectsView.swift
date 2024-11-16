// Copyright Justin Bishop, 2024

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
  enum FilterType {
    case none, contacted, uncontacted
  }

  enum SortType {
    case name, dateAdded
  }

  let filter: FilterType

  @Environment(\.modelContext) var modelContext
  @Query private var prospects: [Prospect]
  @State private var sortType = SortType.name
  @State private var selectedProspects = Set<Prospect>()
  @State private var isShowingScanner = false

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

  private var currentSort: [SortDescriptor<Prospect>] {
    switch sortType {
    case .name:
      return [SortDescriptor(\Prospect.name)]
    case .dateAdded:
      return [
        SortDescriptor(\Prospect.dateAdded, order: .reverse),
        SortDescriptor(\Prospect.name),
      ]
    }
  }

  private var filterPredicate: Predicate<Prospect>? {
    switch filter {
    case .none:
      return nil
    case .contacted:
      return #Predicate { prospect in prospect.isContacted }
    case .uncontacted:
      return #Predicate { prospect in !prospect.isContacted }
    }
  }

  init(filter: FilterType) {
    self.filter = filter
    
    _prospects = Query(filter: filterPredicate, sort: currentSort)
  }

  var body: some View {
    NavigationStack {
      List(prospects, selection: $selectedProspects) { prospect in
        NavigationLink(
          destination: { EditView(prospect: prospect) },
          label: {
            HStack {
              VStack(alignment: .leading) {
                Text(prospect.name)
                  .font(.headline)
                Text(prospect.emailAddress)
                  .foregroundStyle(.secondary)
              }
              Spacer()
              if filter == .none {
                if prospect.isContacted {
                  Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                } else {
                  Image(systemName: "x.circle.fill")
                    .foregroundStyle(.red)
                }
              }
            }
            .tag(prospect)
            .swipeActions {
              Button("Delete", systemImage: "trash", role: .destructive) {
                modelContext.delete(prospect)
              }

              if prospect.isContacted {
                Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                  prospect.isContacted.toggle()
                }
                .tint(.blue)
              } else {
                Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                  prospect.isContacted.toggle()
                }
                .tint(.green)
              }

              Button("Remind Me", systemImage: "bell") {
                addNotification(for: prospect)
              }
              .tint(.orange)
            }
          }
        )
      }
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
          EditButton()
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

  func addNotification(for prospect: Prospect) {
    let center = UNUserNotificationCenter.current()

    let addRequest = {
      let content = UNMutableNotificationContent()
      content.title = "Contact \(prospect.name)"
      content.subtitle = prospect.emailAddress
      content.sound = UNNotificationSound.default

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

      let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: content,
        trigger: trigger
      )
      center.add(request)
    }

    center.getNotificationSettings { settings in
      if settings.authorizationStatus == .authorized {
        addRequest()
      } else {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
          if success {
            addRequest()
          } else if let error {
            print(error.localizedDescription)
          }
        }
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
