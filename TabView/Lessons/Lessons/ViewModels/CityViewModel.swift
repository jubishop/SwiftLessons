import Foundation

struct CityViewModel {
  var city: City
  
  var formatter: MeasurementFormatter {
    let format = MeasurementFormatter()
    format.unitStyle = .short
    format.unitOptions = .providedUnit
    return format
  }
  var name: String {
    return city.name.capitalized
  }
  var temperatureCelsius: String {
    let temperature = Measurement(value: city.weather.temperature, unit: UnitTemperature.celsius)
    return formatter.string(from: temperature)
  }
  var temperatureFahrenheit: String {
    var temperature = Measurement(value: city.weather.temperature, unit: UnitTemperature.celsius)
    temperature.convert(to: UnitTemperature.fahrenheit)
    return formatter.string(from: temperature)
  }
  var feelsCelsius: String {
    let temperature = Measurement(value: city.weather.feels, unit: UnitTemperature.celsius)
    return formatter.string(from: temperature) + " degrees"
  }
  var feelsFahrenheit: String {
    var temperature = Measurement(value: city.weather.feels, unit: UnitTemperature.celsius)
    temperature.convert(to: UnitTemperature.fahrenheit)
    return formatter.string(from: temperature) + " degrees"
  }
  var precipitation: String {
    let precipitation = Measurement(value: city.weather.precipitation, unit: UnitLength.centimeters)
    return formatter.string(from: precipitation)
  }
  var humidity: String {
    return "\(city.weather.humidity) %"
  }
  var wind: String {
    let wind = Measurement(value: city.weather.wind, unit: UnitSpeed.kilometersPerHour)
    return formatter.string(from: wind)
  }
  var pressure: String {
    let pressure = Measurement(value: city.weather.pressure, unit: UnitPressure.millibars)
    return formatter.string(from: pressure)
  }
  var visibility: String {
    let visibility = Measurement(value: city.weather.visibility, unit: UnitLength.kilometers)
    return formatter.string(from: visibility)
  }
}
