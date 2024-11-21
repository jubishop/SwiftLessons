// Copyright Justin Bishop, 2024

import Foundation
import GRDB

extension AppDatabase {
  var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("v1") { db in
      try db.create(table: "card") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("prompt", .text).notNull()
        t.column("answer", .text).notNull()
      }
    }

    return migrator
  }
}
