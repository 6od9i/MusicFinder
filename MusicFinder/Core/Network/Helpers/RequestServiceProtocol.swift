//
//  RequestServiceProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import Combine
import Foundation

protocol RequestServiceProtocol {
    func request<T: Decodable>(_ api: APIEndpointProtocol) -> AnyPublisher<T, Error>
}
