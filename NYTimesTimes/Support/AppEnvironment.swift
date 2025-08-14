//
//  AppEnvironment.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//

import Foundation
import Combine

protocol ArticlesRepository {
    func mostViewed(section: String, period: Int) -> AnyPublisher<[Article], Error>
}

enum AppEnvironment {
    static func makeRepository() -> ArticlesRepository {
        let useStub = ProcessInfo.processInfo.environment["UITest_useStubData"] == "1"
        if useStub {
            return StubArticlesRepository()
        } else {
            return NYTArticlesRepository()
        }
    }
}

struct StubArticlesRepository: ArticlesRepository {
    func mostViewed(section: String, period: Int) -> AnyPublisher<[Article], Error> {
        guard let url = Bundle.main.url(forResource: "Articles_stub", withExtension: "json") else {
            return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(MostViewedResponse.self, from: data)
            return Just(decoded.results)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
