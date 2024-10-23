// Copyright Justin Bishop, 2024

import SwiftUI

struct CurrencyFont: ViewModifier {
  let amount: Double

  func body(content: Content) -> some View {
    content.font(
      amount < 10 ? .body : amount < 100 ? .title : .largeTitle
    )
  }
}

extension View {
  func currencyFont(for amount: Double) -> some View {
    modifier(CurrencyFont(amount: amount))
  }
}

struct ContentView: View {
  @State private var addingExpense = false
  @State private var expenses = Expenses()

  var body: some View {
    NavigationStack {
      List {
        ForEach(expenses.items) { item in
          HStack {
            VStack(alignment: .leading) {
              Text(item.name).font(.headline)
              Text(item.type)
            }
            Spacer()
            Text(
              item.amount,
              format: .currency(code: Locale.current.currency?.identifier ?? "USD")
            )
            .currencyFont(for: item.amount)
          }
        }
        .onDelete(perform: expenses.removeItems)
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

#Preview {
  ContentView()
}
