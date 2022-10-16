import SwiftUI
import demlib

struct PillView: View {
  let option: Database.Property.Option

  var body: some View {
      Text(option.name)
        .foregroundColor(.primary.opacity(0.8))
        .font(.system(size: 11))
        .padding(.horizontal, 4)
        .padding(.vertical, 1)
        .background(
          RoundedRectangle(cornerRadius: 3)
            .fillAndStroke(Color(option.color), strokeColor: .primary.opacity(0.15), strokeWidth: 0.5))
  }
}
