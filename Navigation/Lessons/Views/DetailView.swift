import SwiftUI

struct DetailView: View {
  @Binding var userData: PictureViewModel
  
  var body: some View {
    VStack {
      HStack {
        Text("Rating: ")
          .font(.subheadline)
        Slider(value: $userData.picture.rating,
               in: 0...5,
               step: 1.0)
          .frame(width: 150)
        Text("\(userData.rating)")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(Color.orange)
        Spacer()
      }
      Image(userData.picture.image)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0,
               maxWidth: .infinity,
               minHeight: 0,
               maxHeight: .infinity)
        .clipped()
    }
    .padding(15)
    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
    .navigationBarTitle("Picture", displayMode: .inline)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(userData: .constant(AppData().userData[0]))
  }
}
