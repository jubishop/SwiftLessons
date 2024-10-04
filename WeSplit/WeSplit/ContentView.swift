//
//  ContentView.swift
//  WeSplit
//
//  Created by Justin Bishop on 10/1/24.
//

import SwiftUI

struct ContentView: View {
  let tipPercentages = [10, 15, 20, 25, 0]

  @State private var checkAmount = 0.0
  @State private var numberOfPeople = 2
  @State private var tipPercentage: Int
  @FocusState private var amountIsFocused: Bool

  init() {
    _tipPercentage = State(initialValue: tipPercentages[2])
  }

  var grandTotal: Double {
    let tipAmount = checkAmount * (Double(tipPercentage) / 100)
    return checkAmount + tipAmount
  }

  var totalPerPerson: Double {
    let peopleCount = Double(numberOfPeople + 2)
    return grandTotal / peopleCount
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          LabeledContent("Amount") {
            TextField(
              "Amount", value: $checkAmount,
              format: .currency(
                code: Locale.current.currency?.identifier ?? "USD")
            )
            .keyboardType(.decimalPad)
            .focused($amountIsFocused)
          }

          Picker("Number of people", selection: $numberOfPeople) {
            ForEach(2..<12) {
              Text("\($0) people")
            }
          }
          .pickerStyle(.navigationLink)
        }

        Section("How much tip do you want to leave?") {
          Picker("Tip percentage", selection: $tipPercentage) {
            ForEach(tipPercentages, id: \.self) {
              Text($0, format: .percent)
            }
          }
          .pickerStyle(.segmented)
        }

        Section("Check total") {
          Text(
            grandTotal,
            format: .currency(
              code: Locale.current.currency?.identifier ?? "USD"))
        }

        Section("Amount per person") {
          Text(
            totalPerPerson,
            format: .currency(
              code: Locale.current.currency?.identifier ?? "USD"))
        }
      }
      .navigationTitle("WeSplit")
      .toolbar {
        if amountIsFocused {
          Button("Done") {
            amountIsFocused = false
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
