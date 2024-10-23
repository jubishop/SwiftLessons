// Copyright Justin Bishop, 2024

import SwiftUI

struct CurrencyStyle: ViewModifier {
  let amount: Double

  func body(content: Content) -> some View {
    content
      .font(amount < 10 ? .body : amount < 100 ? .title : .largeTitle)
      .foregroundColor(amount < 10 ? .green : amount < 100 ? .blue : .red)
  }
}

extension View {
  func currencyStyle(for amount: Double) -> some View {
    modifier(CurrencyStyle(amount: amount))
  }
}

struct ContentView: View {
  @State private var addingExpense = false
  @State private var expenses = Expenses()

  var body: some View {
    NavigationStack {
      List {
        ExpenseSection(
          title: "Personal",
          items: expenses.personalItems,
          expenses: expenses
        )
        ExpenseSection(
          title: "Business",
          items: expenses.businessItems,
          expenses: expenses
        )
      }
      .navigationTitle("iExpense")
      .toolbar {
        Button("Add Expense", systemImage: "plus") {
          addingExpense.toggle()
        }
      }
      .sheet(isPresented: $addingExpense) {
        AddView(expenses: expenses)
      }
    }
  }
}

struct ExpenseSection: View {
  let title: String
  let items: [ExpenseItem]
  var expenses: Expenses

  var body: some View {
    Section(title) {
      ForEach(items) { item in
        HStack {
          VStack(alignment: .leading) {
            Text(item.name).font(.headline)
          }
          Spacer()
          Text(
            item.amount,
            format: .currency(code: Locale.current.currency?.identifier ?? "USD")
          )
          .currencyStyle(for: item.amount)
        }
      }
      .onDelete { indexSet in
        expenses.removeItems(at: indexSet, for: title)
      }
    }
  }
}

#Preview {
  ContentView()
}
