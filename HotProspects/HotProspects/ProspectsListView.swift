// Copyright Justin Bishop, 2024

import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsListView: View {
  let filter: FilterType
  let sortType: SortType

  @Environment(\.modelContext) var modelContext
  @Query private var prospects: [Prospect]
  @Binding var path: NavigationPath
  @Binding var selectedProspects: Set<Prospect>

  init(
    path: Binding<NavigationPath>,
    filter: FilterType,
    sortType: SortType,
    selectedProspects: Binding<Set<Prospect>>
  ) {
    self._path = path
    self.filter = filter
    self.sortType = sortType
    self._selectedProspects = selectedProspects

    let currentSort: [SortDescriptor<Prospect>] =
      switch sortType {
      case .name:
        [SortDescriptor(\Prospect.name)]
      case .dateAdded:
        [
          SortDescriptor(\Prospect.dateAdded, order: .reverse),
          SortDescriptor(\Prospect.name),
        ]
      }

    switch filter {
    case .none:
      _prospects = Query(sort: currentSort)
    case .contacted:
      _prospects = Query(filter: #Predicate { prospect in prospect.isContacted }, sort: currentSort)
    case .uncontacted:
      _prospects = Query(
        filter: #Predicate { prospect in !prospect.isContacted },
        sort: currentSort
      )
    }
  }

  var body: some View {
    List(prospects, selection: $selectedProspects) { prospect in
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
        Image(systemName: "chevron.right")
      }
      .tag(prospect)
      .contentShape(Rectangle())
      .onTapGesture {
        path.append(prospect)
      }
      .swipeActions(edge: .leading) {
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
      }
      .swipeActions(edge: .trailing) {
        Button("Delete", systemImage: "trash", role: .destructive) {
          modelContext.delete(prospect)
        }

        Button("Remind Me", systemImage: "bell") {
          addNotification(for: prospect)
        }
        .tint(.orange)
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
}

#Preview {
  ProspectsListView(
    path: .constant(NavigationPath()),
    filter: .none,
    sortType: .name,
    selectedProspects: .constant(Set<Prospect>())
  )
  .modelContainer(DataController.previewContainer)
}
