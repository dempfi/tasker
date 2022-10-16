import SwiftUI

struct LoginView: View {
  var body: some View {
    VStack(alignment: .center) {
      Image("notion")
        .resizable()
        .scaledToFit()
        .frame(width: 60)

      Text("Connecting to Notion")
        .font(.title2)

      Spacer()
        .frame(maxHeight: 2)

      Text("You will be redirected to select a Notion database to be used as a source of tasks")
        .font(.footnote)
        .multilineTextAlignment(.center)

      Spacer()
        .frame(maxHeight: 15)

      Button("Connect to Notion", action: API.shared.connect)
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    .frame(maxWidth: 200, maxHeight: .infinity, alignment: .center)
  }
}
