// Copyright Justin Bishop, 2024

import Foundation
import SwiftUI

struct AlertConfig {
  let title: String
  var message: () -> any View
  var actions: () -> any View
}

extension View {
  func customAlert(config: Binding<AlertConfig?>) -> some View {
    alert(
      config.wrappedValue?.title ?? "",
      isPresented: Binding(
        get: { config.wrappedValue != nil },
        set: { isShown in
          if !isShown {
            config.wrappedValue = nil
          }
        }
      ),
      actions: {
        if let actions = config.wrappedValue?.actions() {
          AnyView(actions)
        } else {
          Button("OK") {}
        }
      },
      message: {
        if let message = config.wrappedValue?.message() {
          AnyView(message)
        } else {
          Text("")
        }
      }
    )
  }
}
