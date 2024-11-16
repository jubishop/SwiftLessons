// Copyright Justin Bishop, 2024

import SwiftData

@MainActor
class DataController {
  static let previewContainer: ModelContainer = {
    do {
      let container = try ModelContainer(
        for: Prospect.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      )
      
      for i in 1...9 {
        let entry = Prospect(
          name: "Name \(i)",
          emailAddress: "Address \(i)",
          isContacted: i.isMultiple(of: 2)
        )
        container.mainContext.insert(entry)
      }
      
      return container
    } catch {
      fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
  }()
}
