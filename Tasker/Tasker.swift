import SwiftUI

  @main
  struct Tasker: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
      if #available(macOS 13, *) {
        return MenuBarExtra {
          MainView()
            .frame(width: 300, height: 400)
        } label: {
          Text("App")
        }
        .menuBarExtraStyle(.window)
      } else {
        return Settings {
          EmptyView()
        }
      }
    }
  }
