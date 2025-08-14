//
//  APIErrorURLSessionTests.swift
//  NYTimesTimes
//
//  Created by ali naveed on 13/08/2025.
//
import Combine
import XCTest
@testable import NYTimesTimes

/// A URLProtocol that lets us fully control URLSession responses.
final class MockURLProtocol: URLProtocol {
    // Either provide a handler or set `error`.
    static var handler: ((URLRequest) throws -> (URLResponse, Data))?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest
    { request }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        guard let handler = MockURLProtocol.handler else {
            fatalError("MockURLProtocol.handler not set")
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

final class APIErrorURLSessionTests: XCTestCase {
    var bag = Set<AnyCancellable>()

    struct BoomError: LocalizedError {
        var errorDescription: String? { "Boom!" }
    }

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    // 1) missingAPIKey (doesn't hit network)
    func testErrorDescription_missingAPIKey() {
        let repo = NYTArticlesRepository(apiKey: "", session: makeSession())
        let exp = expectation(description: "missing key")

        repo.mostViewed().sink { completion in
            if case .failure(let error) = completion {
                if let api = error as? APIError {
                    XCTAssertEqual(api.errorDescription, "API key is missing.")
                    exp.fulfill()
                } else {
                    XCTFail("Expected APIError")
                }
            }
        } receiveValue: { _ in
            XCTFail("Should not succeed")
        }.store(in: &bag)

        wait(for: [exp], timeout: 1.0)
    }

    // 2) invalidResponse (non-HTTPURLResponse)
    func testErrorDescription_invalidResponse() {
        MockURLProtocol.error = nil
        MockURLProtocol.handler = { request in
            let url = URL(string: "https://example.com")!
            let response = URLResponse(
                url: url,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
            return (response, Data())
        }

        let repo = NYTArticlesRepository(apiKey: "key", session: makeSession())
        let exp = expectation(description: "invalid response")

        repo.mostViewed().sink { completion in
            if case .failure(let error) = completion {
                if let api = error as? APIError {
                    XCTAssertEqual(
                        api.errorDescription,
                        "Invalid server response."
                    )
                    exp.fulfill()
                } else {
                    XCTFail("Expected APIError")
                }
            }
        } receiveValue: { _ in
            XCTFail("Should not succeed")
        }.store(in: &bag)

        wait(for: [exp], timeout: 1.0)
    }

    // 3) http(code)
    func testErrorDescription_http403() {
        MockURLProtocol.error = nil
        MockURLProtocol.handler = { request in
            let url = URL(string: "https://example.com")!
            let response = HTTPURLResponse(
                url: url,
                statusCode: 403,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        let repo = NYTArticlesRepository(apiKey: "key", session: makeSession())
        let exp = expectation(description: "http 403")

        repo.mostViewed().sink { completion in
            if case .failure(let error) = completion {
                if let api = error as? APIError {
                    XCTAssertEqual(api.errorDescription, "HTTP error 403.")
                    exp.fulfill()
                } else {
                    XCTFail("Expected APIError")
                }
            }
        } receiveValue: { _ in
            XCTFail("Should not succeed")
        }.store(in: &bag)

        wait(for: [exp], timeout: 1.0)
    }

    // 4) decoding(error) (HTTP 200 with invalid JSON)
    func testErrorDescription_decoding() {
        MockURLProtocol.error = nil
        MockURLProtocol.handler = { request in
            let url = URL(string: "https://example.com")!
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            // Invalid JSON for MostViewedResponse
            let data = Data("{\"unexpected\":\"shape\"}".utf8)
            return (response, data)
        }

        let repo = NYTArticlesRepository(apiKey: "key", session: makeSession())
        let exp = expectation(description: "decoding")

        repo.mostViewed().sink { completion in
            if case .failure(let error) = completion {
                if let api = error as? APIError, let desc = api.errorDescription
                {
                    XCTAssertTrue(
                        desc.hasPrefix("Decoding failed:"),
                        "desc=\(desc)"
                    )
                    exp.fulfill()
                } else {
                    XCTFail("Expected APIError.decoding")
                }
            }
        } receiveValue: { _ in
            XCTFail("Should not succeed")
        }.store(in: &bag)

        wait(for: [exp], timeout: 1.0)
    }

    // 5) underlying(error) (transport error raised by URL loading system)
    func testErrorDescription_underlying() {
        MockURLProtocol.handler = nil
        MockURLProtocol.error = BoomError()  // deterministic message "Boom!"

        let repo = NYTArticlesRepository(apiKey: "key", session: makeSession())
        let exp = expectation(description: "underlying")

        repo.mostViewed().sink { completion in
            if case .failure(let error) = completion {
                if let api = error as? APIError {
                    XCTAssertEqual(api.errorDescription, "The operation couldn’t be completed. (NSURLErrorDomain error -1.)")
                    exp.fulfill()
                } else {
                    XCTFail("Expected APIError.underlying")
                }
            }
        } receiveValue: { _ in
            XCTFail("Should not succeed")
        }.store(in: &bag)

        wait(for: [exp], timeout: 1.0)
    }

}
