// Copyright Justin Bishop, 2024

import SwiftData

@MainActor
class DataController {
  static let previewContainer: ModelContainer = {
    do {
      let container = try ModelContainer(
        for: Expense.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      )
      
      for i in 1...9 {
        let expense = Expense(
          name: "Name \(i)",
          type: i % 2 == 0 ? Expense.ExpenseType.business : Expense.ExpenseType.personal,
          amount: Double(i * 2)
        )
        container.mainContext.insert(expense)
      }
      
      return container
    } catch {
      fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
  }()
}
