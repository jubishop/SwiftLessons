import SwiftUI

struct SettingsCitiesView: View {
  @EnvironmentObject var appData: AppData
  @Binding var selected: Int

  var body: some View {
    Group {
      VStack(alignment: .leading, spacing: 10) {
        Text("Select City")
          .font(.footnote)
        ForEach(0..<3) { index in
          Button(appData.userData[index].name) {
            self.appData.selectedCity = index
            self.selected = 0
          }
        }
        Spacer()
      }
      .padding()
    }
    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.9))
    .cornerRadius(15)
    .padding()
  }
}

struct SettingsCitiesView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsCitiesView(selected: .constant(0))
      .environmentObject(AppData())
  }
}
