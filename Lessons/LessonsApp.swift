import SwiftUI

@main
struct LessonsApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(appData: AppData())
        }
    }
}

struct LessonsApp_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(appData: AppData())
  }
}
