// Copyright Justin Bishop, 2024

import SwiftUI

struct AddView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss

  @State private var name = ""
  @State private var type = Expense.ExpenseType.business
  @State private var amount = 0.0

  var body: some View {
    NavigationStack {
      VStack {
        Form {
          TextField("Expense Name", text: $name)

          Picker("Type", selection: $type) {
            ForEach(Expense.ExpenseType.allCases, id: \.self) { type in
              Text(type.rawValue).tag(type)
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
              modelContext.insert(Expense(name: name, type: type, amount: amount))
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
      .navigationTitle("Add Expense")
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
  AddView().modelContainer(DataController.previewContainer)
}
