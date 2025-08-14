//
//  ArticlesRepository.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import Foundation
import Combine

final class NYTArticlesRepository: ArticlesRepository {
    private let client: NetworkClient
    private let apiKey: String

    /// Designated init that can auto-create a NetworkManager when `client` is nil.
    init(
        apiKey: String = APIConstants.apiKey,
        client: NetworkClient? = nil,
        session: URLSession = .shared
    ) {
        self.client = client ?? NetworkManager(baseURL: URL(string: APIConstants.baseURL)!, session: session)
        self.apiKey = apiKey
    }

    func mostViewed(section: String = "all-sections", period: Int = 7) -> AnyPublisher<[Article], Error> {
        guard !apiKey.isEmpty else {
            return Fail(error: APIError.missingAPIKey).eraseToAnyPublisher()
        }

        return client.request(NYTEndpoints.mostPopular())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}

