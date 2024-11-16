// Copyright Justin Bishop, 2024

import SwiftData
import SwiftUI

struct EditView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  
  @State var prospect: Prospect
  
  var body: some View {
    Form {
      TextField("Name", text: $prospect.name)
      TextField("Email Address", text: $prospect.emailAddress)
      Toggle("Contacted", isOn: $prospect.isContacted)
      Button("Save") {
        try? modelContext.save()
        dismiss()
      }
    }
  }
}

#Preview {
  let container = DataController.previewContainer
  let descriptor = FetchDescriptor<Prospect>()
  let prospects = try? container.mainContext.fetch(descriptor)
  EditView(prospect: prospects!.randomElement()!).modelContainer(container)
}
