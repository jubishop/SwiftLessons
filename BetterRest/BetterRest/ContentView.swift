//
//  ContentView.swift
//  BetterRest
//
//  Created by Justin Bishop on 10/16/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
  @State private var wakeUp =
    Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? .now
  @State private var sleepAmount = 8.0
  @State private var coffeeAmount = 4.0

  var body: some View {
    NavigationStack {
      VStack {
        Form {
          Section("When do you want to wake up?") {
            DatePicker(
              "Please enter a time",
              selection: $wakeUp,
              displayedComponents: .hourAndMinute
            )
            .labelsHidden()
          }

          Section("Desired amount of sleep") {
            Stepper(
              "\(sleepAmount.formatted()) hours",
              value: $sleepAmount,
              in: 4...12,
              step: 0.25
            )
          }

          Section("Daily coffee intake") {
            Slider(value: $coffeeAmount, in: 1...20, step: 1)
            Text("\(coffeeAmount, specifier: "%.0f") cups")
          }
        }
        Text("Go to sleep at \(calculateBedtime())")
          .font(.largeTitle)
          .frame(maxWidth: .infinity, alignment: .center)
      }
      .navigationTitle("BetterRest")
    }
  }

  func calculateBedtime() -> String {
    do {
      let config = MLModelConfiguration()
      let model = try SleepCalculator(configuration: config)

      let components = Calendar.current.dateComponents(
        [.hour, .minute],
        from: wakeUp
      )
      let prediction = try model.prediction(
        wake: Double((components.hour ?? 0) * 3600 + (components.minute ?? 0) * 60),
        estimatedSleep: sleepAmount,
        coffee: Double(coffeeAmount)
      )

      let sleepTime = wakeUp - prediction.actualSleep
      return sleepTime.formatted(date: .omitted, time: .shortened)
    } catch {
      return "Sorry, there was a problem calculating your bedtime."
    }
  }
}

#Preview {
  ContentView()
}
