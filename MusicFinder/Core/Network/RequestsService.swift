//
//  RequestsService.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Combine
import Foundation

final class RequestsService: RequestServiceProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ api: APIEndpointProtocol) -> AnyPublisher<T, Error> {
        guard let url = URL(string: api.path) else {
            return Fail(error: RequestsError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        let headers = api.headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return session
            .dataTaskPublisher(request: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
