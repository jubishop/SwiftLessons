//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Justin Bishop on 10/15/24.
//

import SwiftUI

struct BlueFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.largeTitle)
      .fontWeight(.bold)
      .foregroundColor(.blue)
  }
}

extension View {
  func blueFont() -> some View {
    modifier(BlueFont())
  }
}

struct GridStack<Content: View, Header: View>: View {
  let rows: Int
  let columns: Int
  @ViewBuilder let content: (Int, Int) -> Content
  @ViewBuilder let header: () -> Header

  var body: some View {
    VStack {
      header()
      Spacer()
      ForEach(0..<rows, id: \.self) { row in
        HStack {
          ForEach(0..<columns, id: \.self) { column in
            content(row, column)
          }
        }
      }
    }
  }
}

struct ContentView: View {
  var body: some View {
    GridStack(rows: 4, columns: 4) { row, col in
      Image(systemName: "\(row * 4 + col).circle")
      Text("R\(row) C\(col)")
    } header: {
      Text("Grid Header")
        .blueFont()
      Text("And more")
    }
  }
}

#Preview {
  ContentView()
}
