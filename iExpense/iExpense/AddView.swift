// Copyright Justin Bishop, 2024

import SwiftUI

struct AddView: View {
  @Environment(\.dismiss) var dismiss
  var expenses: Expenses
  @State private var name = ""
  @State private var type = "Personal"
  @State private var amount = 0.0

  let types = ["Business", "Personal"]

  var body: some View {
    NavigationStack {
      VStack {
        Form {
          TextField("Name", text: $name)

          Picker("Type", selection: $type) {
            ForEach(types, id: \.self) { type in
              Text(type)
            }
          }

          TextField(
            "Amount",
            value: $amount,
            format: .currency(code: Locale.current.currency?.identifier ?? "USD")
          )
          .keyboardType(.decimalPad)

          Section {
            Button("Submit") {
              expenses.addItem(ExpenseItem(name: name, type: type, amount: amount))
              dismiss()
            }
            .disabled(name.isEmpty || amount.isZero)
          }
        }
      }
      .navigationTitle("Add new expense")
    }
  }
}

#Preview {
  AddView(expenses: Expenses())
}
