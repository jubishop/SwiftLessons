import SwiftUI

struct WeatherView: View {
  @EnvironmentObject var appData: AppData

  var body: some View {
    let city = appData.userData[appData.selectedCity]

    return ZStack {
      Image("clouds")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
      VStack {
        Text(city.name)
          .font(Font.system(size: 30))
        Text(appData.celsius ? city.temperatureCelsius : city.temperatureFahrenheit)
          .font(Font.system(size: 70))
        WeatherDataView(city: city)
        WeatherFeelsView(city: city, celsius: appData.celsius)
        Spacer()
      }
      .padding(.top, 80)
    }
  }
}

struct WeatherView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherView().environmentObject(AppData())
  }
}
