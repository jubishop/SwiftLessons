// Copyright Justin Bishop, 2024

import SwiftUI

struct CheckoutView: View {
  var order: Order
  @State private var confirmationMessage = ""
  @State private var showingConfirmation = false

  var body: some View {
    ScrollView {
      VStack {
        AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
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
    .alert("Thank you!", isPresented: $showingConfirmation) {
      Button("OK") {}
    } message: {
      Text(confirmationMessage)
    }
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
      confirmationMessage =
        "Your order for \(decodedOrder.quantity) \(decodedOrder.type) cupcakes is on its way!"
      showingConfirmation = true
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

