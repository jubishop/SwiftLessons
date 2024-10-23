// Copyright Justin Bishop, 2024

import Foundation

@Observable
class Expenses {
  private static let storageKey = "Items"
  private(set) var items: [ExpenseItem] = []

  init() {
    if let savedItems = UserDefaults.standard.data(forKey: Self.storageKey),
      let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems)
    {
      items = decodedItems
    }
  }

  func removeItems(at offsets: IndexSet) {
    items.remove(atOffsets: offsets)
    storeItems()
  }

  func addItem(_ item: ExpenseItem) {
    items.append(item)
    storeItems()
  }

  private func storeItems() {
    do {
      let encoded = try JSONEncoder().encode(items)
      UserDefaults.standard.set(encoded, forKey: Self.storageKey)
    } catch {
      fatalError("Failed to save expenses: \(error.localizedDescription)")
    }
  }
}
