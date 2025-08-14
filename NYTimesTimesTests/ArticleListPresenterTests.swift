//
//  ArticleListPresenterTests.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
import XCTest
import SwiftUI
import Combine
@testable import NYTimesTimes

final class ArticleListPresenterTests: XCTestCase {
    var bag = Set<AnyCancellable>()

    final class InteractorStub: ArticleListInteractorProtocol {
        let publisher: AnyPublisher<[Article], Error>
        init(publisher: AnyPublisher<[Article], Error>) { self.publisher = publisher }
        func fetchMostViewed(section: String, period: Int) -> AnyPublisher<[Article], Error> { publisher }
    }

    final class RouterStub: ArticleListRouterProtocol {
        func makeDetail(for article: Article) -> AnyView { AnyView(Text(article.title)) }
    }

    func testPresenterLoadsSuccess() {
        let articles = [Article(id: 1, url: "https://e.com", title: "A", byline: "By", publishedDate: "2025-01-15", updated: nil, media: nil)]
        let interactor = InteractorStub(publisher: Just(articles).setFailureType(to: Error.self).eraseToAnyPublisher())
        let presenter = ArticleListPresenter(interactor: interactor, router: RouterStub())

        let exp = expectation(description: "loaded")
        presenter.$state.dropFirst().sink { state in
            if case .loaded = state { exp.fulfill() }
        }.store(in: &bag)

        presenter.onAppear()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(presenter.articles.count, 1)
    }

    func testPresenterHandlesFailure() {
        enum Fake: Error { case boom }
        let interactor = InteractorStub(publisher: Fail<[Article], Error>(error: Fake.boom).eraseToAnyPublisher())
        let presenter = ArticleListPresenter(interactor: interactor, router: RouterStub())

        let exp = expectation(description: "failed")
        presenter.$state.dropFirst().sink { state in
            if case .failed = state { exp.fulfill() }
        }.store(in: &bag)

        presenter.onAppear()
        wait(for: [exp], timeout: 1.0)
    }
}
