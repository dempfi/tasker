import JSON

struct Entry: Identifiable, Hashable {
  let id: String
  let url: String
  let title: String
  let properties: [Property]

  init?(from json: JSON) {
    if let id = json.id.string, let url = json.url.string, let properties = json.properties.object {
      self.id = id
      self.url = url
      self.title = properties.values.first { $0.type.string == "title" }?.title.0.plain_text.string ?? "Untitled"
      self.properties = properties.values.compactMap(Property.init(from: ))
    } else {
      return nil
    }
  }
}


extension Entry {
  enum Property: Identifiable, Hashable {
    case status(id: String, Database.Property.Option),
         select(id: String, Database.Property.Option)

    init?(from json: JSON) {
      switch json.type {
      case "status":
        if !json.status.isNull {
          self = .status(id: json.id.string!, Database.Property.Option(from: json.status)!)
        } else {
          return nil
        }
      case "select":
        if let option =  Database.Property.Option(from: json.select) {
                  self = .select(id: json.id.string!, option)
        } else {
          return nil
        }
      default: return nil
      }
    }

    var id: String {
      switch self {
      case let .select(id: id, _): return id
      case let .status(id: id, _): return id
      }
    }
  }
}
