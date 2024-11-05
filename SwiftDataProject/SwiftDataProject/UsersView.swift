import SwiftData
import SwiftUI

struct UsersView: View {
  @Query var users: [User]

  init(
    minimumJoinDate: Date = .distantPast,
    sortOrder: [SortDescriptor<User>] = [SortDescriptor(\User.name)]
  ) {
    _users = Query(
      filter: #Predicate<User> { user in
        user.joinDate >= minimumJoinDate
      },
      sort: sortOrder
    )
  }

  var body: some View {
    List(users) { user in
      HStack {
        Text(user.name)
        
        Spacer()
        
        Text(String(user.jobs.count))
          .fontWeight(.black)
          .padding(.horizontal, 10)
          .padding(.vertical, 5)
          .background(.blue)
          .foregroundStyle(.white)
          .clipShape(.capsule)
      }
    }
  }
}

#Preview {
  UsersView()
    .modelContainer(for: User.self)
}
