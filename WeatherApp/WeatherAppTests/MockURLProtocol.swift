//
//  MockURLProtocol.swift
//  WeatherApp
//
//  Created by Rosh on 01/02/25.
//
// MockURLProtocol.swift
import Foundation

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var responseError: Error?
    static var responseStatusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool {
        // Return true for the requests you want to mock
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let data = MockURLProtocol.responseData {
            // Mock successful response
            let response = HTTPURLResponse(url: request.url!, statusCode: MockURLProtocol.responseStatusCode, httpVersion: nil, headerFields: nil)
            client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        } else if let error = MockURLProtocol.responseError {
            // Mock error response
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Clean up
    }
}
