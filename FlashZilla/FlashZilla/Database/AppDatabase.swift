// Copyright Justin Bishop, 2024

import Foundation
import GRDB

final class AppDatabase: Sendable {
  private let dbWriter: any DatabaseWriter

  static func empty() -> AppDatabase {
    do {
      let dbPool = try DatabasePool(
        path: URL.documentsDirectory.appending(path: "db.sqlite").path,
        configuration: makeConfiguration()
      )
      return try AppDatabase(dbPool)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  static func shared() -> AppDatabase {
    do {
      let dbQueue = try DatabaseQueue(
        path: URL.documentsDirectory
          .appending(path: "db.sqlite")
          .absoluteString,
        configuration: makeConfiguration()
      )
      return try AppDatabase(dbQueue)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  init(_ dbWriter: any GRDB.DatabaseWriter) throws {
    self.dbWriter = dbWriter
    do {
      try migrator.migrate(dbWriter)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  static func makeConfiguration() -> Configuration {
    var config = Configuration()
    #if DEBUG
      config.publicStatementArguments = true
    #endif
    return config
  }

  private var migrator: DatabaseMigrator {
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

  public func read<T>(_ block: (Database) throws -> T) throws -> T {
    return try dbWriter.read { db in
      try block(db)
    }
  }

  public func write(_ block: @escaping (Database) throws -> Void) throws {
    try dbWriter.write(block)
  }
}
