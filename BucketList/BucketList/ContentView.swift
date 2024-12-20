// Copyright Justin Bishop, 2024

import JubiSwift
import LocalAuthentication
import MapKit
import SwiftUI

struct ContentView: View {
  @State private var viewModel = ViewModel()
  @State private var selectedMapStyle: CustomMapStyle = .standard
  @State private var alertConfig: AlertConfig?

  let startPosition = MapCameraPosition.region(
    MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
      span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
  )

  var body: some View {
    if viewModel.isUnlocked {
      MapReader { proxy in
        ZStack {
          Map(initialPosition: startPosition) {
            ForEach(viewModel.locations) { location in
              Annotation(location.name, coordinate: location.coordinate) {
                Image(systemName: "star.circle")
                  .resizable()
                  .foregroundStyle(.red)
                  .frame(width: 32, height: 32)
                  .background(.white)
                  .clipShape(.circle)
                  .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                      .onEnded { _ in viewModel.selectedPlace = location }
                  )
                // TODO: Replace with this:
                //              .onLongPressGesture {
                //                selectedPlace = location
                //              }
              }
            }
          }
          .mapStyle(selectedMapStyle.mapStyle)
          .onTapGesture { position in
            if let coordinate = proxy.convert(position, from: .local) {
              viewModel.addLocation(at: coordinate)
            }
          }
          .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
              viewModel.update(location: newLocation)
            }
          }

          VStack(alignment: .trailing) {
            Spacer()
            HStack(alignment: .center) {
              Spacer()
              Picker("Select map style", selection: $selectedMapStyle) {
                ForEach(CustomMapStyle.allCases) { style in
                  Text(style.rawValue.capitalized).tag(style)
                }
              }
              .pickerStyle(MenuPickerStyle())
              .padding(4)
              .background(Color.white)
              .cornerRadius(8)
            }
            .padding(.trailing)
          }
          .padding(.top)
        }
      }
    } else {
      Button("Unlock Places") {
        viewModel.authenticate(LAContext()) { error in
          alertConfig = AlertConfig(
            title: "Error",
            message: {
              Text(error?.localizedDescription ?? "Unknown Authentication Error")
            }
          )
        }
      }
      .padding()
      .background(.blue)
      .foregroundStyle(.white)
      .clipShape(.capsule)
      .customAlert(config: $alertConfig)
    }
  }
}

#Preview {
  ContentView()
}
