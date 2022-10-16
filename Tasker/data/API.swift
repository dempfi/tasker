import AppKit
import Foundation
import JSON
import Networking

struct API: NetworkingService {
  enum Error: Swift.Error {
    case error
  }

  static let shared = API()

  let network = NetworkingClient(baseURL: "https://api.notion.com/v1/")

  private init() {
    network.headers["Notion-Version"] = "2022-06-28"
    auth(token: UserDefaults.standard.string(forKey: "token") ?? "")
  }

  func connect() {
    NSWorkspace.shared.open(URL(string: "https://tasker.dempfi.com/connect")!)
  }

  func auth(token: String) {
    network.headers["Authorization"] = "Bearer \(token)"
  }

  func database() async throws -> Database? {
    let response: JSON = try await post("search", params: [:])
    guard let item = response.results.array?.first(where: { $0["object"] == "database" }) else {
      return nil
    }

    var database = try Database(from: item)
    database.entries = try await entries(database.id)
    return database
  }

  func entries(_ id: String) async throws -> [Entry] {
    let response: JSON = try await post("databases/\(id)/query")
    return response.results.array!.compactMap(Entry.init(from: ))
  }

  func title(_ id: String) async throws -> String? {
    let response: JSON = try await get("pages/\(id)/properties/title")
    return response.results.0.title.plain_text.string
  }
}
