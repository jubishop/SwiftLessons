// Copyright Justin Bishop, 2024

import SwiftUI

struct RatingView: View {
  @Binding var rating: Int

  var label = ""
  var maximumRating = 5
  var offImage: Image?
  var onImage = Image(systemName: "star.fill")
  var offColor = Color.gray
  var onColor = Color.yellow

  var body: some View {
    HStack {
      if !label.isEmpty {
        Text(label)
      }

      ForEach(1..<maximumRating + 1, id: \.self) { number in
        Button(
          action: {
            rating = number
          },
          label: {
            image(for: number)
          }
        )
      }
    }
    .buttonStyle(.plain)
  }

  func image(for number: Int) -> some View {
    (number > rating ? (offImage ?? onImage) : onImage)
      .foregroundStyle(number > rating ? offColor : onColor)
  }
}

#Preview {
  RatingView(rating: .constant(4))
}
