// Copyright Justin Bishop, 2024

import GRDB
import SwiftUI

@main
struct FlashZillaApp: App {
  init() {
    var migrator = DatabaseMigrator()
    migrator.registerMigration("Create cards") { db in
      try db.create(table: "card") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("prompt", .text).notNull()
        t.column("answer", .text).notNull()
      }
    }
    do {
      let dbQueue = try DatabaseQueue(
        path: URL.documentsDirectory
          .appending(path: "db.sqlite")
          .absoluteString
      )
      try migrator.migrate(dbQueue)
      print(URL.documentsDirectory
        .appending(path: "db.sqlite")
        .absoluteString)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
