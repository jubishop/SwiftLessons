// Copyright Justin Bishop, 2024

import Foundation
import GRDB

struct Card: Codable,
  Identifiable,
  Equatable,
  FetchableRecord,
  MutablePersistableRecord,
  TableRecord
{
  var id: Int64?
  var prompt: String
  var answer: String

  mutating func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }

  enum Columns {
    static let id = Column(CodingKeys.id)
    static let prompt = Column(CodingKeys.prompt)
    static let answer = Column(CodingKeys.answer)
  }
  
  static let example = Card(
    prompt: "Who played the 13th Doctor in Doctor Who?",
    answer: "Jodie Whittaker"
  )
}
