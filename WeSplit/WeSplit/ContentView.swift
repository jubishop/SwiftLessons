//
//  ContentView.swift
//  WeSplit
//
//  Created by Justin Bishop on 10/1/24.
//

import SwiftUI

struct ContentView: View {
  @State private var checkAmount = 0.0
  @State private var numberOfPeople = 2
  @State private var tipPercentage = 20.0
  @FocusState private var amountIsFocused: Bool

  var grandTotal: Double {
    let tipAmount = checkAmount * (tipPercentage / 100)
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
          Slider(value: $tipPercentage, in: 0...100, step: 1) {
            Text("Tip percentage")
          }
          Text("Tip: \(Int(tipPercentage))%")
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
