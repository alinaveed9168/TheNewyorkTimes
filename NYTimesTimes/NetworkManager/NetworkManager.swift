//
//  NetworkClient.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import Combine
import Foundation

// MARK: - Network Client Protocol
protocol NetworkClient {
    func request<T: Decodable>(_ endpoint: Endpoint<T>) -> AnyPublisher<
        T, Error
    >
}

// MARK: - URLSession-backed implementation
final class NetworkManager: NetworkClient {
    private let baseURL: URL
    private let session: URLSession
    private let defaultDecoder: JSONDecoder

    init(
        baseURL: URL,
        session: URLSession = .shared,
        defaultDecoder: JSONDecoder = .init()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultDecoder = defaultDecoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint<T>) -> AnyPublisher<T, Error> {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let normalizedPath = endpoint.path.hasPrefix("/") ? endpoint.path : "/" + endpoint.path
        components.path = normalizedPath
        components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        let decoder = endpoint.decoder ?? defaultDecoder

        return session.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let http = output.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                guard (200..<300).contains(http.statusCode) else {
                    // ← key change: surface the HTTP status
                    throw APIError.http(http.statusCode, data: output.data)
                }
                return output.data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> Error in
                // ← preserve APIError if already thrown
                if let api = error as? APIError { return api }
                if error is DecodingError { return APIError.decoding(error) }
                return APIError.underlying(error)
            }
            .eraseToAnyPublisher()
    }

}
