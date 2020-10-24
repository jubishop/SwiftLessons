import SwiftUI

struct ContentView: View {
  @State private var selectedView:Int = 0

  var body: some View {
    TabView(selection: $selectedView) {
      WeatherView()
        .tabItem({
          Image(systemName: "sun.max")
          Text("Weather")
        }).tag(0)
      SettingsView(selected: $selectedView)
        .tabItem({
          Image(systemName: "gear")
          Text("Settings")
        }).tag(1)
    }
    .edgesIgnoringSafeArea(.top)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(AppData())
  }
}
