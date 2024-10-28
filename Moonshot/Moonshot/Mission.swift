// Copyright Justin Bishop, 2024

import Foundation

struct Mission: Codable, Identifiable, Hashable {
  struct CrewRole: Codable {
    let name: String
    let role: String
  }

  let id: Int // Identifiable
  let launchDate: Date?
  let crew: [CrewRole]
  let description: String

  var displayName: String {
    "Apollo \(id)"
  }

  var image: String {
    "apollo\(id)"
  }

  var formattedLaunchDate: String {
    launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
  }
  
  // Hashable
  func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
  static func == (lhs: Mission, rhs: Mission) -> Bool {
      lhs.id == rhs.id
  }

}
