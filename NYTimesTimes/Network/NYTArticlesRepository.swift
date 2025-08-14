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
    private static let defaultBaseURL = URL(string: "https://api.nytimes.com")!

    /// Designated init that can auto-create a URLSessionNetworkClient when `client` is nil.
    init(
        apiKey: String,
        client: NetworkClient? = nil,
        baseURL: URL = defaultBaseURL,
        session: URLSession = .shared
    ) {
        self.client = client ?? URLSessionNetworkClient(baseURL: baseURL, session: session)
        self.apiKey = apiKey
    }

    /// Keep this if you want explicit DI in some call sites.
    init(client: NetworkClient, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func mostViewed(section: String = "all-sections", period: Int = 7) -> AnyPublisher<[Article], Error> {
        guard !apiKey.isEmpty else {
            return Fail(error: APIError.missingAPIKey).eraseToAnyPublisher()
        }

        let endpoint = Endpoint<MostViewedResponse>(
            path: "/svc/mostpopular/v2/mostviewed/\(section)/\(period).json",
            queryItems: [URLQueryItem(name: "api-key", value: apiKey)]
        )

        return client.request(endpoint)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}

