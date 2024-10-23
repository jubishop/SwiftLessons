import SwiftUI

struct WeatherDataView: View {
  var city: CityViewModel

  var body: some View {
    Group {
      LazyVGrid(
        columns: [
          GridItem(.fixed(110)),
          GridItem(.flexible()),
        ],
        alignment: .leading,
        spacing: 10
      ) {
        Text("Precipitation:")
        Text(city.precipitation)
        Text("Humidity:")
        Text(city.humidity)
        Text("Wind:")
        Text(city.wind)
        Text("Pressure:")
        Text(city.pressure)
        Text("Visibility:")
        Text(city.visibility)
      }
      .padding()
    }
    .background(
      Color(
        red: 0.9,
        green: 0.9,
        blue: 0.9,
        opacity: 0.8
      )
    )
    .cornerRadius(15)
    .padding()
  }
}

struct WeatherDataView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherDataView(city: AppData().userData[0])
  }
}
