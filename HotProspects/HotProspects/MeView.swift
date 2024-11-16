// Copyright Justin Bishop, 2024

import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
  @AppStorage("name") private var name = "Anonymous"
  @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"

  let context = CIContext()
  let filter = CIFilter.qrCodeGenerator()

  @State private var qrCode = UIImage()

  var body: some View {
    NavigationStack {
      Form {
        TextField("Name", text: $name)
          .textContentType(.name)
          .font(.title)
          .autocapitalization(.words)

        TextField("Email address", text: $emailAddress)
          .textContentType(.emailAddress)
          .font(.title)
          .autocapitalization(.none)

        Image(uiImage: qrCode)
          .interpolation(.none)
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
          .contextMenu {
            ShareLink(
              item: Image(uiImage: qrCode),
              preview: SharePreview("My QR Code", image: Image(uiImage: qrCode))
            )
          }
      }
      .navigationTitle("Your code")
      .onAppear(perform: updateCode)
      .onChange(of: name, updateCode)
      .onChange(of: emailAddress, updateCode)
    }
  }

  func updateCode() {
    qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
  }

  func generateQRCode(from string: String) -> UIImage {
    filter.message = Data(string.utf8)

    if let outputImage = filter.outputImage {
      if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
        return UIImage(cgImage: cgimg)
      }
    }
    return UIImage(systemName: "xmark.circle") ?? UIImage()
  }
}

#Preview {
  MeView()
}
