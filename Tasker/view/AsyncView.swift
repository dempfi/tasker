import SwiftUI

enum LoadingState<Value> {
  case idle
  case loading
  case failed(Error)
  case loaded(Value)
}

@MainActor
protocol LoadableObject: ObservableObject {
  associatedtype Output
  var state: LoadingState<Output> { get }
  func load()
}

struct AsyncView<Source: LoadableObject, Content: View>: View {
  @ObservedObject var source: Source
  var content: (Source.Output) -> Content

  init(
    source: Source,
    @ViewBuilder content: @escaping (Source.Output) -> Content
  ) {
    self.source = source
    self.content = content
  }

  var body: some View {
    switch source.state {
    case .idle:
      Color.clear.onAppear(perform: source.load)
    case .loading:
      ProgressView()
    case let .failed(error):
      Text("Errror")
      Button("Connect to Notion", action: API.shared.connect)
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
//            ErrorView(error: error, retryHandler: source.load)
    case let .loaded(output):
      content(output)
    }
  }
}
