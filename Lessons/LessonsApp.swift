import SwiftUI

@main
struct LessonsApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView().environmentObject(AppData())
    }
  }
}

struct LessonsApp_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(AppData())
  }
}
