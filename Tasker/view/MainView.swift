import SwiftUI

struct MainView: View {
  @AppStorage("token") var token: String?

  var body: some View {
      if token != nil {
        TasksView()
          .background(.thickMaterial)
      } else {
        LoginView()
      }
  }
}
