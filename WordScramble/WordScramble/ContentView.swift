// Copyright Justin Bishop, 2024

import SwiftUI

struct Person: Identifiable, CustomStringConvertible {
  var id: String { name }
  let name: String
  let age: Int

  var description: String {
    "\(name), \(age) years old"
  }
}

struct ContentView: View {
  let people = [
    Person(name: "Alice", age: 28),
    Person(name: "Bob", age: 35),
    Person(name: "Charlie", age: 42),
  ]

  var body: some View {
    List(people) { person in
      Text("\(person)")
    }
  }
}

#Preview {
  ContentView()
}
