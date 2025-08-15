//
//  URLSessionProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Combine
import Foundation

protocol URLSessionProtocol {
    func dataTaskPublisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error>
}

extension URLSession: URLSessionProtocol {
    func dataTaskPublisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        self.dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
