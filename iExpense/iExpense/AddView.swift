// Copyright Justin Bishop, 2024

import SwiftUI

struct AddView: View {
  @Environment(\.dismiss) var dismiss
  var expenses: Expenses
  @State private var name = "Expense Name"
  @State private var type = "Personal"
  @State private var amount = 0.0

  let types = ["Business", "Personal"]

  var body: some View {
    NavigationStack {
      VStack {
        Form {
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
            Button(action: {
              expenses.addItem(ExpenseItem(name: name, type: type, amount: amount))
              dismiss()
            }) {
              HStack {
                Image(systemName: "square.and.arrow.down")
                Text("Save")
              }
            }
            .disabled(name.isEmpty || amount.isZero)
          }
        }
      }
      .navigationTitle($name)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  AddView(expenses: Expenses())
}
