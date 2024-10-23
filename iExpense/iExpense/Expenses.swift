// Copyright Justin Bishop, 2024

import Foundation

@Observable
class Expenses {
  private static let storageKey = "Items"
  private(set) var items: [ExpenseItem] = []

  var personalItems: [ExpenseItem] {
    items.filter { $0.type == "Personal" }
  }

  var businessItems: [ExpenseItem] {
    items.filter { $0.type == "Business" }
  }

  init() {
    if let savedItems = UserDefaults.standard.data(forKey: Self.storageKey),
      let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems)
    {
      items = decodedItems
    }
  }

  func removeItems(at offsets: IndexSet, for type: String) {
    let itemsToRemove = type == "Personal" ? personalItems : businessItems
    let itemsToRemoveIds = offsets.map { itemsToRemove[$0].id }
    items.removeAll { itemsToRemoveIds.contains($0.id) }
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
