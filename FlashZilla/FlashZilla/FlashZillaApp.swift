// Copyright Justin Bishop, 2024

import GRDB
import SwiftUI

extension EnvironmentValues {
  @Entry var cardRepository = CardRepository.empty()
}

extension View {
  func cardRepository(_ appDatabase: AppDatabase) -> some View {
    self.environment(\.cardRepository, CardRepository(appDatabase))
  }
}

@main
struct FlashZillaApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView().cardRepository(.shared)
    }
  }
}
