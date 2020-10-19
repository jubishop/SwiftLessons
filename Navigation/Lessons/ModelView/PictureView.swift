import Foundation

struct PictureViewModel : Identifiable, Hashable {
  static func == (lhs: PictureViewModel, rhs: PictureViewModel) -> Bool {
    lhs.id == rhs.id
  }

  let id = UUID()

  var picture: Picture
  var rating:Int {
    return Int(picture.rating)
  }
  var name:String {
    return picture.image
  }
}
