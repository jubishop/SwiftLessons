import Foundation

struct PictureViewModel: Identifiable, Hashable {
  static func == (lhs: PictureViewModel, rhs: PictureViewModel) -> Bool {
    lhs.id == rhs.id
  }

  let id = UUID()

  var picture: Picture
  var rating: Int {
    Int(picture.rating)
  }
  var name: String {
    picture.image
  }
}
