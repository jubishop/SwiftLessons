// Copyright Justin Bishop, 2024

import SwiftData
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
  @Environment(\.modelContext) var modelContext
  
  static let sortOrder = [SortDescriptor(\Expense.amount, order: .reverse)]
  @Query(
    filter: #Predicate<Expense> { expense in
      expense.type == "Business"
    }, sort: Self.sortOrder
  ) var businessExpenses: [Expense]
  @Query(
    filter: #Predicate<Expense> { expense in
      expense.type == "Personal"
    }, sort: Self.sortOrder
  ) var personalExpenses: [Expense]

  var body: some View {
    NavigationStack {
      List {
        ExpenseSection(
          title: "Personal",
          expenses: personalExpenses
        )
        ExpenseSection(
          title: "Business",
          expenses: businessExpenses
        )
      }
      .navigationTitle("iExpense")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          NavigationLink {
            AddView()
          } label: {
            HStack {
              Image(systemName: "plus").font(.body.bold())
              Text("Add Expense")
            }
          }
        }
      }
    }
  }
}

struct ExpenseSection: View {
  @Environment(\.modelContext) var modelContext
  let title: String
  var expenses: [Expense]

  var body: some View {
    Section(title) {
      ForEach(expenses) { expense in
        HStack {
          VStack(alignment: .leading) {
            Text(expense.name).font(.headline)
          }
          Spacer()
          Text(
            expense.amount,
            format: .currency(code: Locale.current.currency?.identifier ?? "USD")
          )
          .currencyStyle(for: expense.amount)
        }
      }
      .onDelete { indexSet in
        for index in indexSet {
          modelContext.delete(expenses[index])
        }
      }
    }
  }
}

#Preview {
  ContentView().modelContainer(DataController.previewContainer)
}
