//
//  ArticleListInteractorTests.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
import XCTest
import Combine
@testable import NYTimesTimes

final class ArticleListInteractorTests: XCTestCase {
    var bag = Set<AnyCancellable>()

    struct RepoStub: ArticlesRepository {
        let result: Result<[Article], Error>
        func mostViewed(section: String, period: Int) -> AnyPublisher<[Article], Error> {
            result.publisher.eraseToAnyPublisher()
        }
    }

    func testFetchMostViewed_Success() {
        let expected = [Article(id: 1, url: "https://e.com", title: "A", byline: "By", publishedDate: "2025-01-15", updated: nil, media: nil)]
        let interactor = ArticleListInteractor(repository: RepoStub(result: .success(expected)))

        let exp = expectation(description: "fetch")
        interactor.fetchMostViewed(section: "all-sections", period: 7)
            .sink { completion in
                if case .failure(let e) = completion { XCTFail("Unexpected error \(e)") }
            } receiveValue: { articles in
                XCTAssertEqual(articles[0].byline, expected[0].byline)
                exp.fulfill()
            }
            .store(in: &bag)
        wait(for: [exp], timeout: 1.0)
    }

    func testFetchMostViewed_Failure() {
        enum Fake: Error { case boom }
        let interactor = ArticleListInteractor(repository: RepoStub(result: .failure(Fake.boom)))

        let exp = expectation(description: "fail")
        interactor.fetchMostViewed(section: "all-sections", period: 7)
            .sink { completion in
                if case .failure = completion { exp.fulfill() }
            } receiveValue: { _ in
                XCTFail("Should fail")
            }
            .store(in: &bag)
        wait(for: [exp], timeout: 1.0)
    }
}
