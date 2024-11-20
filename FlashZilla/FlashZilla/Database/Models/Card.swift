// Copyright Justin Bishop, 2024

import Foundation
import GRDB

class Card: Codable,
  Identifiable,
  Equatable,
  FetchableRecord,
  PersistableRecord,
  TableRecord,
  CustomStringConvertible
{
  var id: Int64?
  var prompt: String
  var answer: String

  func didInsert(_ inserted: InsertionSuccess) {
    id = inserted.rowID
  }

  enum Columns {
    static let id = Column(CodingKeys.id)
    static let prompt = Column(CodingKeys.prompt)
    static let answer = Column(CodingKeys.answer)
  }

  static func == (lhs: Card, rhs: Card) -> Bool { lhs.id == rhs.id }

  var description: String {
    "Card(id: \(id ?? 0), prompt: \"\(prompt)\", answer: \"\(answer)\")"
  }

  #if DEBUG
    static let example = Card(
      prompt: "Who played the 13th Doctor in Doctor Who?",
      answer: "Jodie Whittaker"
    )
  #endif

  init(
    id: Int64? = Int64.random(in: Int64.min...Int64.max),
    prompt: String,
    answer: String
  ) {
    self.id = id
    self.prompt = prompt
    self.answer = answer
  }
}
