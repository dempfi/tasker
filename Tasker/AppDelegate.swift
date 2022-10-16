import AppKit
import JSON
import SwiftUI

final class HostingView<Content: View>: NSHostingView<Content> {
  override func viewDidMoveToWindow() {
    window?.becomeKey()
  }
}

private final class MenuContainer: NSObject {
  fileprivate var statusBar: NSStatusBar
  fileprivate var statusItem: NSStatusItem
  fileprivate var mainMenu: NSMenu!
  fileprivate var view: NSView

  override init() {
    statusBar = NSStatusBar.system
    statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
    view = HostingView(rootView: MainView())
    view.frame = NSRect(x: 0, y: 0, width: 300, height: 400)
    super.init()
    createMenu()
  }

  private func createMenu() {
    if let statusBarButton = statusItem.button {
      statusBarButton.image = NSImage(
        systemSymbolName: "checkmark.square.fill",
        accessibilityDescription: nil
      )?.withSymbolConfiguration(.init(pointSize: 14, weight: .medium))

      mainMenu = NSMenu()
      let mainItem = NSMenuItem()
      mainItem.view = view
      mainMenu.addItem(mainItem)
      statusItem.menu = mainMenu
    }
  }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
  private var container: MenuContainer!

  func applicationDidFinishLaunching(_: Notification) {
    if #unavailable(macOS 13) {
      container = MenuContainer()
    }
  }

  func application(_: NSApplication, open urls: [URL]) {
    let components = URLComponents(url: urls.first!, resolvingAgainstBaseURL: false)
    guard let data = components?.queryItems?.first else { return }
    guard let value = data.value?.data(using: .utf8), data.name == "data" else { return }
    guard let auth = try? JSONDecoder().decode(JSON.self, from: value) else { return }
    let iconData = auth.workspace_icon.string!.replacingOccurrences(of: "%", with: "\\").data(using: .utf8)!

    API.shared.auth(token: auth.access_token.string!)
    UserDefaults.standard.set(auth.access_token.string, forKey: "token")
    UserDefaults.standard.set(auth.workspace_id.string, forKey: "workspaceId")
    UserDefaults.standard.set(auth.workspace_name.string, forKey: "workspaceName")
    UserDefaults.standard.set(String(data: iconData, encoding: .nonLossyASCII), forKey: "workspaceIcon")
    UserDefaults.standard.set(auth.bot_id.string, forKey: "botId")

    if let menuConfiguration = container {
      menuConfiguration.statusItem.popUpMenu(menuConfiguration.mainMenu)
    }
  }
}
