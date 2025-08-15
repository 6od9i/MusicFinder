//
//  SessionMock.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
@testable import MusicFinder
import Combine

final class SessionMock: URLSessionProtocol {
    var data: Data?
    var error: Error?
    var response: URLResponse?
    var request: URLRequest?
    
    func dataTaskPublisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        self.request = request
        if let error {
            return Fail(outputType: (data: Data, response: URLResponse).self, failure: error)
                .eraseToAnyPublisher()
        }
        
        let data = data ?? Data()
        let response = response ?? URLResponse(
            url: request.url!,
            mimeType: nil,
            expectedContentLength: data.count,
            textEncodingName: nil
        )
        
        return Just((data: data, response: response))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
