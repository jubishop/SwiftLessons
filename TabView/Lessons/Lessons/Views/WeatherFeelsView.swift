import SwiftUI
struct WeatherFeelsView: View {
  var city: CityViewModel
  var celsius: Bool
  
  var body: some View {
    Group {
      HStack(alignment: .top, spacing: 0) {
        Text("Feels Like:")
          .frame(width: 120, alignment: .leading)
        Text(celsius ? city.feelsCelsius : city.feelsFahrenheit)
          .font(Font.body.weight(.semibold))
      }.padding()
    }
    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.8))
    .cornerRadius(15)
    .padding([.leading, .trailing])
  }
}

struct WeatherFeelsView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherFeelsView(city: AppData().userData[0], celsius: false)
  }
}
