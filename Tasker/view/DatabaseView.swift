import SwiftUI
import SDWebImageSwiftUI

struct DatabaseView: View {
  let database: Database
  @AppStorage("properties") var selection: [String] = []

  var emoji: Text {
    switch database.icon {
    case let .emoji(emoji): return Text(emoji)
    default: return Text("")
    }
  }

  var body: some View {
    Menu {
      ForEach(database.properties.values.map { $0 }, id: \.id) { property in
        Button {
          if selection.contains(property.id) {
            selection.remove(at: selection.firstIndex(of: property.id)!)
          } else {
            selection.append(property.id)
          }
        } label: {
          if selection.contains(property.id) {
            let image = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)!.withSymbolConfiguration(.init(pointSize: 11, weight: .bold))!

            Image(nsImage: image)
          } else {
            Spacer().frame(width: 13)
          }

          Text(property.name)
        }
      }
    } label: {
      emoji +
        Text(database.title)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
          .font(.system(size: 13))
    } primaryAction: {
      NSWorkspace.shared.open(URL(string: database.url)!)
    }
      .menuStyle(.borderlessButton)
      .fixedSize()
  }
}
