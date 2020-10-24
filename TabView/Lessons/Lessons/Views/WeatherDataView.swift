import SwiftUI

struct WeatherDataView: View {
  var city: CityViewModel
  
  var body: some View {
    Group {
      HStack(alignment: .top, spacing: 0) {
        VStack(alignment: .leading, spacing: 10) {
          Text("Precipitation:")
          Text("Humidity:")
          Text("Wind:")
          Text("Pressure:")
          Text("Visibility:")
        }.frame(width: 120, alignment: .leading)
        
        VStack(alignment: .leading, spacing: 10) {
          Text(city.precipitation)
          Text(city.humidity)
          Text(city.wind)
          Text(city.pressure)
          Text(city.visibility)
        }.font(Font.body.weight(.semibold))
      }.padding()
    }
    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.8))
    .cornerRadius(15)
    .padding()
  }
}

struct WeatherDataView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherDataView(city: AppData().userData[0])
  }
}
