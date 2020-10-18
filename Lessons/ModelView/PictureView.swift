import Foundation

struct PictureViewModel : Identifiable {
  let id = UUID()

  var picture: Picture
  var rating:Int {
    return Int(picture.rating)
  }
  var name:String {
    return picture.image
  }
}
