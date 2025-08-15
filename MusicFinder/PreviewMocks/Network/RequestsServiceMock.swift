//
//  RequestsServiceMock.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Combine
import Foundation

#if DEBUG || TESTING

class RequestsServiceMock: RequestServiceProtocol {
    var error: Error?
    var data: Data?
    var delay: Int = 0
    var lastAPI: APIEndpointProtocol?
    
    init(error: Error? = nil, data: Data? = nil, delay: Int = 0) {
        self.error = error
        self.data = data
        self.delay = delay
    }
    
    func request<T>(_ api: APIEndpointProtocol) -> AnyPublisher<T, any Error> where T: Decodable {
        lastAPI = api
        if let error {
            return Fail(error: error)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        if let data {
            do {
                return Just(try JSONDecoder().decode(T.self, from: data))
                    .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error)
                    .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
        }
        return Fail(error: RequestsError.noMoreData)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

#endif
