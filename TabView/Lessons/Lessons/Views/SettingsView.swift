import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var appData: AppData
  @Binding var selected: Int

  var body: some View {
    ZStack {
      Image("seaside")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
      VStack {
        SettingsMeasurementView(celsius: $appData.celsius)
        SettingsCitiesView(selected: $selected)
      }
      .foregroundColor(Color.black)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(selected: .constant(1)).environmentObject(AppData())
  }
}
