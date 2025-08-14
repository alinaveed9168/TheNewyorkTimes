//
//  APIError.swift
//  NYTimesTimes
//
//  Created by ali naveed on 11/08/2025.
//
import Foundation

enum APIError: Error, LocalizedError {
    case missingAPIKey
    case invalidResponse
    case http(Int, data: Data? = nil)
    case decoding(Error)
    case underlying(Error)
    
    public var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "API key is missing."
        case .invalidResponse: return "Invalid server response."
        case .http(let code, _): return "HTTP error \(code)."
        case .decoding(let err): return "Decoding failed: \(err.localizedDescription)"
        case .underlying(let err): return err.localizedDescription
        }
    }
}
