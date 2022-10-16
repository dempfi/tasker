import JSON
import demlib

extension Database {
  enum Property {
    struct Option: Hashable {
      let id: String
      let name: String
      let color: String

      init?(from json: JSON) {
        if let id = json.id.string, let name = json.name.string, let color = json.color.string {
          self.id = id
          self.name = name
          self.color = color
        } else {
          return nil
        }
      }
    }

    struct StatusGroup {
      let id: String
      let name: String
      let color: String
      let options: [Option]

      init?(from json: JSON, with options: [String: Option]) {
        if let id = json.id.string, let name = json.name.string, let color = json.color.string, let ids = json.option_ids.array {
          self.id = id
          self.name = name
          self.color = color
          self.options = ids.compactMap(\.string).compactMap { options[$0] }
        } else {
          return nil
        }
      }
    }

    case status(id: String, String, StatusGroup, StatusGroup, StatusGroup),
         select(id: String, String, [Option])

    init?(from json: JSON) {
      switch json.type.string {
      case "status":
        let options = json.status.options.array!.compactMap(Option.init(from:)).collect(\.id)
        let groups = json.status.groups.array!.compactMap { StatusGroup(from: $0, with: options) }
        let todo = groups.first { $0.name == "To-do" }
        let inProgress = groups.first { $0.name == "In progress" }
        let done = groups.first { $0.name == "Complete" }
        self = .status(id: json.id.string!, json.name.string!, todo!, inProgress!, done!)
      case "select":
        let options = json.select.options.array!.compactMap(Option.init(from:))
        self = .select(id: json.id.string!, json.name.string!, options)
        print(self)
      default: return nil
      }
    }

    var id: String {
      switch self {
      case let .select(id: id, _, _): return id
      case let .status(id: id, _, _, _, _): return id
      }
    }

    var name: String {
      switch self {
      case let .select(id: _, name, _): return name
      case let .status(id: _, name, _, _, _): return name
      }
    }
  }
}
