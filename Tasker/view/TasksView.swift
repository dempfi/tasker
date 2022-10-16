import SwiftUI

@MainActor
class Model: LoadableObject {
  @Published private(set) var state = LoadingState<Database>.idle

  func load() {
    state = .loading
    Task {
      do {
        state = .loaded(try await API.shared.database()!)
      } catch {
        state = .failed(API.Error.error)
      }
    }
  }
}

struct TasksView: View {
  @StateObject var model = Model()

  var body: some View {
    AsyncView(source: model) { database in
      VStack(alignment: .leading, spacing: 0) {
        HeaderView(database: database)

        Rectangle()
          .fill(.white.opacity(0.1))
          .frame(maxWidth: .infinity, maxHeight: 0.5)
          .padding(.horizontal, 15)

        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading, spacing: 0) {
            ForEach(database.entries, id: \.id) { entry in
              EntryView(entry: entry)
            }
          }
          .padding(.horizontal, 5)
          .padding(.top, 5)
        }
        .mask(
          LinearGradient(stops: [
            Gradient.Stop(color: .white, location: 0.96),
            Gradient.Stop(color: .white.opacity(0), location: 1)
          ], startPoint: .top, endPoint: .bottom)
        )

        HStack(spacing: 4) {
          Image(systemName: "plus")
          Text("New")
        }
        .foregroundColor(.primary.opacity(0.5))
        .font(.system(size: 13))
        .padding(.horizontal, 15)
        .padding(.bottom, 3)
        .padding(.top, 6)
      }
    }
  }
}
