// Copyright Justin Bishop, 2024

import SwiftUI

struct CheckoutView: View {
  var order: Order
  @State private var alertMessage = ""
  @State private var alertTitle = ""
  @State private var showingAlert = false
  @State private var alertConfig: AlertConfig?

  var body: some View {
    ScrollView {
      VStack {
        AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .scaledToFit()

          case .empty:
            ProgressView()

          default:
            Image(systemName: "photo.fill")
              .font(.system(size: 40))
              .foregroundColor(.gray)
              .frame(width: 100, height: 100)
          }
        }

        Text("Your total is \(order.cost, format: .currency(code: "USD"))")
          .font(.title)

        Button(action: {
          Task {
            await placeOrder()
          }
        }) {
          HStack {
            Image(systemName: "cart.fill")
            Text("Place Order")
            Image(systemName: "chevron.right")
          }
          .padding(.vertical)
          .frame(maxWidth: .infinity)
          .background(Color.green)
          .foregroundColor(.white)
          .cornerRadius(10)
          .shadow(radius: 5)
        }
        .containerRelativeFrame(.horizontal) { size, axis in
          size * 0.75
        }
        .padding(.vertical)
      }
    }
    .navigationTitle("Check out")
    .navigationBarTitleDisplayMode(.inline)
    .scrollBounceBehavior(.basedOnSize)
    .alert(alertTitle, isPresented: $showingAlert) {
      Button("OK") {}
    } message: {
      Text(alertMessage)
    }
    .customAlert(config: $alertConfig)
  }

  func placeOrder() async {
    guard let encoded = try? JSONEncoder().encode(order) else {
      fatalError("Failed to encode order")
    }

    var request = URLRequest(url: URL(string: "https://reqres.in/api/cupcakes")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
      let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
      let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
      alertConfig = .init(
        title: "Thank You",
        message: {
          Text("Your order is placed")
        },
        actions: {
          Button("OK") {
          }
        }
      )
//      alertTitle = "Thank You"
//      alertMessage =
//        "Your order for \(decodedOrder.quantity) \(decodedOrder.type) cupcakes is on its way!"
//      showingAlert = true
    } catch {
      fatalError("Checkout failed: \(error.localizedDescription)")
    }
  }
}

#Preview {
  NavigationStack {
    CheckoutView(order: Order())
  }
}
