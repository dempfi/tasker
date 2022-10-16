import SwiftUI

struct EntryView: View {
  @State var hovered: Bool = false
  let entry: Entry

  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(entry.title)
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(.primary)
        .lineLimit(1)

      HStack {
        ForEach(entry.properties, id: \.id) { property in
          switch property {
          case let .status(_, option): PillView(option: option)
          case let .select(_, option): PillView(option: option)
          }
        }
      }
    }
    .frame(maxWidth: .infinity, minHeight: 18, alignment: .leading)
    .padding(.horizontal, 10)
    .padding(.top, 3)
    .padding(.bottom, 7)
    .background(
      RoundedRectangle(cornerRadius: 4, style: .continuous)
        .fill(.primary.opacity(hovered ? 0.1 : 0))
    )
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(.primary.opacity(hovered ? 0 : 0.1))
        .frame(maxWidth: .infinity, maxHeight: 0.5)
        .padding(.horizontal, 10)
    }
    .onHover {
      hovered = $0
    }
    .onTapGesture {
      NSWorkspace.shared.open(URL(string: entry.url)!)
    }
  }
}
