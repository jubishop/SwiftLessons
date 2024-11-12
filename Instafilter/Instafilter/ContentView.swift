// Copyright Justin Bishop, 2024

import CoreImage
import CoreImage.CIFilterBuiltins
import JubiSwift
import PhotosUI
import StoreKit
import SwiftUI

extension UIImage {
  func fixOrientation() -> UIImage? {
    if imageOrientation == .up {
      return self
    }
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: size))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

struct ContentView: View {
  @AppStorage("filterCount") var filterCount = 0
  @Environment(\.requestReview) var requestReview

  static let context = CIContext()

  @State private var selectedItem: PhotosPickerItem?
  @State private var processedImage: Image?
  @State private var filterIntensity = 0.5
  @State private var filterRadius = 20.0
  @State private var filterScale = 5.0
  @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
  @State private var currentTask: Task<Void, Never>?
  @State private var confirmationDialogConfig: ConfirmationDialogConfig?
  @State private var inputImage: UIImage?

  var body: some View {
    NavigationStack {
      VStack {
        Spacer()

        PhotosPicker(
          selection: $selectedItem,
          matching: .all(of: [.images, .not(.screenshots)])
        ) {
          if let processedImage {
            processedImage
              .resizable()
              .scaledToFit()
          } else {
            ContentUnavailableView(
              "No Picture",
              systemImage: "photo.badge.plus",
              description: Text("Import a photo to get started")
            )
          }
        }
        .buttonStyle(.plain)
        .onChange(of: selectedItem) {
          Task {
            do {
              try await loadImage()
              if let inputImage = inputImage {
                currentFilter.setValue(CIImage(image: inputImage), forKey: kCIInputImageKey)
              }
              applyProcessing()
            } catch {
              return
            }
          }
        }

        Spacer()

        Group {
          if (currentFilter.inputKeys.contains(kCIInputIntensityKey)) {
            HStack {
              Text("Intensity")
              Slider(value: $filterIntensity, in: 0.1...2)
                .onChange(of: filterIntensity, applyProcessing)
                .disabled(processedImage == nil)
            }
          }
          
          if (currentFilter.inputKeys.contains(kCIInputRadiusKey)) {
            HStack {
              Text("Radius")
              Slider(value: $filterRadius, in: 10...100)
                .onChange(of: filterRadius, applyProcessing)
                .disabled(processedImage == nil)
            }
          }
          
          if (currentFilter.inputKeys.contains(kCIInputScaleKey)) {
            HStack {
              Text("Scale")
              Slider(value: $filterScale, in: 10...100)
                .onChange(of: filterScale, applyProcessing)
                .disabled(processedImage == nil)
            }
          }
        }

        HStack {
          Button("Change Filter", action: changeFilter)
            .disabled(processedImage == nil)

          Spacer()

          if let processedImage {
            ShareLink(
              item: processedImage,
              preview: SharePreview("Instafilter image", image: processedImage)
            )
          }
        }.padding(.top)
      }
      .padding([.horizontal, .bottom])
      .navigationTitle("Instafilter")
      .customConfirmationDialog(config: $confirmationDialogConfig)
    }
  }

  func loadImage() async throws {
    guard let imageData = try await selectedItem?.loadTransferable(type: Data.self),
      let uiImage = UIImage(data: imageData)?.fixOrientation()
    else {
      return
    }

    inputImage = uiImage
  }

  func applyProcessing() {
    currentTask?.cancel()
    currentTask = Task {
      do {
        try Task.checkCancellation()
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
          currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
          currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
          currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)
        }

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = Self.context.createCGImage(outputImage, from: outputImage.extent) else {
          return
        }

        let uiImage = UIImage(cgImage: cgImage)
        try Task.checkCancellation()
        DispatchQueue.main.async {
          self.processedImage = Image(uiImage: uiImage)
        }
      } catch {
        return
      }
    }
  }

  func setFilter(_ filter: CIFilter) {
    currentFilter = filter
    if let inputImage = inputImage {
      currentFilter.setValue(CIImage(image: inputImage), forKey: kCIInputImageKey)
    }
    applyProcessing()

    filterCount += 1
    if filterCount % 20 == 0 {
      requestReview()
    }
  }

  func changeFilter() {
    confirmationDialogConfig = ConfirmationDialogConfig(
      title: "Select a Filter",
      actions: {
        Button("Crystallize") { setFilter(CIFilter.crystallize()) }
        Button("Edges") { setFilter(CIFilter.edges()) }
        Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
        Button("Pixellate") { setFilter(CIFilter.pixellate()) }
        Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
        Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
        Button("Vignette") { setFilter(CIFilter.vignette()) }
        Button("Cancel", role: .cancel) {}
      },
      message: { Text("Choose the filter you want to apply") }
    )
  }

}

#Preview {
  ContentView()
}
