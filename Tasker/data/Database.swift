import JSON

struct Database {
  enum Icon {
    case emoji(String),
         url(String)
  }

  let id: String
  let icon: Icon?
  let title: String
  let url: String
  var entries = [Entry]()
  let properties: [String: Property]

  init(from json: JSON) throws {
    id = json.id.string!
    if let emoji = json.icon.emoji.string {
      icon = .emoji(emoji)
    } else {
      icon = .url(json.icon.external.url.string!)
    }
    title = json.title.0.plain_text.string!
    url = json.url.string!
    properties = json.properties.object!.values.compactMap(Property.init(from: )).collect(\.id)
  }
}
