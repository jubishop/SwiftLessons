import Foundation

class AppData: ObservableObject {
  @Published var userData: [PictureViewModel]
  
  init() {
    userData = [
      PictureViewModel(picture: Picture(image: "spot1", rating: 0)),
      PictureViewModel(picture: Picture(image: "spot2", rating: 0)),
      PictureViewModel(picture: Picture(image: "spot3", rating: 0))
    ]
  }
}
