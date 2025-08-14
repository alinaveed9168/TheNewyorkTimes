//
//  ArticleListView.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import SwiftUI

struct ArticleListView: View {
    @StateObject var presenter: ArticleListPresenter

    init(presenter: ArticleListPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        NavigationView {
            Group {
                switch presenter.state {
                case .idle, .loading:
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .failed(let message):
                    VStack(spacing: 12) {
                        Text(message).multilineTextAlignment(.center)
                        Button("Retry") { presenter.retry() }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded:
                    if presenter.articles.isEmpty {
                        EmptyStateView(title: "No Articles",
                                       message: "Try again later.")
                    } else {
                        List(presenter.articles, id: \.id) { article in
                            NavigationLink(destination: presenter.destination(for: article)) {
                                ArticleRowView(article: article)
                            }
                            .accessibilityIdentifier("ArticleRow_\(article.id)")
                        }
                        .listStyle(.plain)
                        .refreshable { presenter.retry() }
                    }
                }
            }
            .navigationTitle("NYTimes")
        }
        .onAppear { presenter.onAppear() }
    }
}

#if DEBUG
struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArticleListView(presenter: PreviewFactory.loaded(articles: Article.mockList))
                .preferredColorScheme(.light)
                .previewDisplayName("Loaded • Dark")
        }
    }
}

// MARK: - Preview Factory
enum PreviewFactory {
    
    static func loaded(articles: [Article]) -> ArticleListPresenter {
          let p = makePresenter()
          p.state = .loaded
          p.articles = articles
          return p
      }

    // Central place to create your presenter for previews.
    private static func makePresenter() -> ArticleListPresenter {
        let repo = AppEnvironment.makeRepository()
        let interactor = ArticleListInteractor(repository: repo)
        let router = ArticleListRouter()
        let presenter = ArticleListPresenter(interactor: interactor, router: router)
        return presenter
    }
}

private extension Article {
    static func mock(
        id: Int = 1,
        url: String = "https://example.com",
        title: String = "Mock Title",
        byline: String = "By Mock Writer",
        publishedDate: String = "2025-01-15",
        updated: String? = nil,
        media: [Media]? = nil
    ) -> Article {
        Article(id: id, url: url, title: title, byline: byline,
                publishedDate: publishedDate, updated: updated, media: media)
    }

    static var mockList: [Article] {
        [
            .mock(id: 1001, title: "SwiftUI Previews Done Right"),
            .mock(id: 1002, title: "Combine in Practice"),
            .mock(id: 1003, title: "Async/Await Tips")
        ]
    }
}
#endif
