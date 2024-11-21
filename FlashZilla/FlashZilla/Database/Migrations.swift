// Copyright Justin Bishop, 2024

import Foundation
import GRDB

enum Migrations {
  static func migrate(_ dbWriter: DatabaseWriter) throws {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("v1") { db in
      try db.create(table: "card") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("prompt", .text).notNull()
        t.column("answer", .text).notNull()
      }
    }
    
    try migrator.migrate(dbWriter)
  }
}
