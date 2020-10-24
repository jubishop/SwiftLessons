import Foundation

class AppData: ObservableObject {
  @Published var userData: [CityViewModel]
  @Published var celsius: Bool = true
  @Published var selectedCity: Int = 0
  
  init() {
    userData = [
      CityViewModel(city: City(name: "Toronto", weather: WeatherData(temperature: 21, precipitation: 0.0, humidity: 83, wind: 0.0, pressure: 1.016, visibility: 14.5, feels: 24))),
      CityViewModel(city: City(name: "New York", weather: WeatherData(temperature: 18, precipitation: 3.0, humidity: 95, wind: 12.4, pressure: 1.020, visibility: 8.5, feels: 15))),
      CityViewModel(city: City(name: "Paris", weather: WeatherData(temperature: 24, precipitation: 8.7, humidity: 90, wind: 5.4, pressure: 1.055, visibility: 10.5, feels: 25)))
    ]
  }
}
