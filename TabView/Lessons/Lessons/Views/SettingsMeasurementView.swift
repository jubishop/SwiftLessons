import SwiftUI

struct SettingsMeasurementView: View {
  @Binding var celsius: Bool

  var body: some View {
    Group {
      HStack(alignment: .top, spacing: 0) {
        Button("Celsius") {
          self.celsius = true
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(celsius ? Color.yellow : Color.clear)
        .disabled(celsius)

        Button("Fahrenheit") {
          self.celsius = false
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(!celsius ? Color.yellow : Color.clear)
        .disabled(!celsius)
      }
      .padding()
    }
    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.9))
    .cornerRadius(15)
    .padding()
  }
}

struct SettingsMeasurementView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsMeasurementView(celsius: .constant(false))
  }
}
