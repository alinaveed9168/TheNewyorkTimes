//
//  APIErrorTests.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
import XCTest
@testable import NYTimesTimes

final class APIErrorTests: XCTestCase {

    enum Boom: LocalizedError {
        case boom
        var errorDescription: String? { "Boom!" }
    }

    func testMissingAPIKeyDescription() {
        XCTAssertEqual(APIError.missingAPIKey.errorDescription, "API key is missing.")
    }

    func testInvalidResponseDescription() {
        XCTAssertEqual(APIError.invalidResponse.errorDescription, "Invalid server response.")
    }

    func testHTTPDescription() {
        XCTAssertEqual(APIError.http(418).errorDescription, "HTTP error 418.")
    }

    func testDecodingDescriptionUsesUnderlyingLocalizedDescription() {
        let desc = APIError.decoding(Boom.boom).errorDescription
        XCTAssertEqual(desc, "Decoding failed: Boom!")
    }

    func testUnderlyingDescriptionUsesUnderlyingLocalizedDescription() {
        XCTAssertEqual(APIError.underlying(Boom.boom).errorDescription, "Boom!")
    }
}
