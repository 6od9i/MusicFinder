//
//  RequestsServiceTests.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Testing
@testable import MusicFinder
import Combine
import Foundation

struct RequestsServiceTests {

    struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
    }
    
    @Test func testInvalidURL() async throws {
        // Arrange
        let api = APIMock(path: "")
        let session = SessionMock()
        let service = RequestsService(session: session)
        var receivedError: Error?
        
        // Act
        _ = service.request(api)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
            }, receiveValue: { (_: TestModel) in })
                    
        // Assert
        assert(receivedError as? RequestsError == .invalidURL, "Should be RequestsError.invalidURL")
    }
    
    @Test func testCorrectlURL() async throws {
        // Arrange
        let expectedPath = "google.com"
        let api = APIMock(path: expectedPath)
        let session = SessionMock()
        let service = RequestsService(session: session)
        
        // Act
        _ = service.request(api).sink(receiveCompletion: { _ in }, receiveValue: { (_: TestModel) in })
        
        // Assert
        assert(session.request?.url?.absoluteString == expectedPath, "URL should not change")
    }

    @Test func testHeadersSetCorrectly() async throws {
        // Arrange
        let expectedHeaders = ["Authorization": "Bearer token"]
        let api = APIMock(headers: expectedHeaders)
        let session = SessionMock()
        let service = RequestsService(session: session)
        
        // Act
        _ = service.request(api).sink(receiveCompletion: { _ in }, receiveValue: { (_: TestModel) in })
        
        // Assert
        assert(session.request?.allHTTPHeaderFields == expectedHeaders, "Headers should be set correctly")
    }
    
    @Test func testRequestFailure() async throws {
        // Arrange
        let api = APIMock()
        let session = SessionMock()
        let error = NSError(domain: "", code: 404)
        session.error = error
        let service = RequestsService(session: session)
        var receivedError: Error?
        
        // Act
        _ = service.request(api)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
            }, receiveValue: { (_: TestModel) in })
                    
        // Assert
        assert(receivedError as? NSError == error, "Should be error")
    }
    
    @Test func testInvalidDecoding() async throws {
        // Arrange
        let json = Data("invalid json".utf8)
        let api = APIMock()
        let session = SessionMock()
        session.data = json
        let service = RequestsService(session: session)
        var receivedError: Error?
        
        // Act
        _ = service.request(api)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
            }, receiveValue: { (_: TestModel) in })
        await Task.yield()
        
        // Assert
        assert(receivedError != nil, "Should be decoding error")
    }
    
    @Test func testSuccessfulDecoding() async throws {
        // Arrange
        let json = """
                {"id": 1, "name": "Test"}
                """.data(using: .utf8)!
        let api = APIMock()
        let session = SessionMock()
        session.data = json
        let service = RequestsService(session: session)
        var result: TestModel?
        
        // Act
        _ = service.request(api)
            .sink(receiveCompletion: { _ in }, receiveValue: { (value: TestModel) in
                result = value
            })
        
        // Assert
        assert(result == TestModel(id: 1, name: "Test"))
    }
}
