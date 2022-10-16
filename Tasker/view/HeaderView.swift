import SwiftUI

struct HeaderView: View {
  @AppStorage("workspaceName") var workspace: String?
  @AppStorage("workspaceIcon") var icon: String?
  var database: Database

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 2) {
      DatabaseView(database: database)

      Spacer()

      Group {
        Text(icon ?? "")
        Text(workspace ?? "")
          .foregroundColor(.primary.opacity(0.5))
          .onTapGesture(perform: API.shared.connect)
      }
      .font(.system(size: 13))
    }
    .padding(.horizontal, 15)
    .padding(.vertical, 9)
  }
}
