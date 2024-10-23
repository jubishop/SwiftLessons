import SwiftUI

struct ContentView: View {
  @EnvironmentObject var appData: AppData

  var body: some View {
    VStack {
      NavigationView {
        EnumList(appData.userData) { index, userData in
          NavigationLink(
            "🖼 \(userData.name): (Rating: \(userData.rating))",
            destination: DetailView(userData: $appData.userData[index])
          )
        }
        .navigationBarTitle("Menu")
      }
      Button(
        action: {
          appData.userData.append(
            PictureViewModel(picture: Picture(image: "husky", rating: 0))
          )
        },
        label: {
          Text("AddEntry")
        }
      )
      Button(
        action: {
          appData.userData.removeLast()
        },
        label: {
          Text("RemoveEntry")
        }
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(AppData())
  }
}
