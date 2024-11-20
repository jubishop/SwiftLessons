// Copyright Justin Bishop, 2024

import GRDB
import SwiftUI

extension EnvironmentValues {
  @Entry var appDatabase = AppDatabase.empty()
}

extension View {
  func appDatabase(_ appDatabase: AppDatabase) -> some View {
    self.environment(\.appDatabase, appDatabase)
  }
}

struct AppView: View {
  @Environment(\.appDatabase) var appDatabase
  
  var body: some View {
    ContentView(appDatabase: appDatabase)
  }
}

@main
struct FlashZillaApp: App {
  var body: some Scene {
    WindowGroup {
      AppView().appDatabase(.shared())
    }
  }
}
