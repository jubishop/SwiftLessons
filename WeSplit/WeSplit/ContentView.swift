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
  @State private var tipPercentage = 20

  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField(
            "Amount", value: $checkAmount,
            format: .currency(
              code: Locale.current.currency?.identifier ?? "USD")
          )
          .keyboardType(.decimalPad)

          Picker("Number of people", selection: $numberOfPeople) {
            ForEach(2..<100) {
              Text("\($0) people")
            }
          }.pickerStyle(.navigationLink)
        }
      }.navigationTitle("WeSplit")
    }
  }
}

#Preview {
  ContentView()
}
