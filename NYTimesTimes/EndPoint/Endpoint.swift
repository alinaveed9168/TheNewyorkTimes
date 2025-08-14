//
//  Endpoint.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
import Foundation

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Endpoint
struct Endpoint<Response: Decodable> {
    let path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var body: Data?
    var decoder: JSONDecoder?

    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        decoder: JSONDecoder? = nil,
        includeAPIKey: Bool = true
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.decoder = decoder

        // Ensure "api-key" is present once (and allow override if caller supplied one).
        if includeAPIKey, !queryItems.contains(where: { $0.name == "api-key" }) {
            self.queryItems = [URLQueryItem(name: "api-key", value: APIConstants.apiKey)] + queryItems
        } else {
            self.queryItems = queryItems
        }
    }
}
