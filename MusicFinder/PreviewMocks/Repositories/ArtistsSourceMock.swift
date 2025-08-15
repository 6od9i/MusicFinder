//
//  ArtistsSourceMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation
import Combine

#if DEBUG || TESTING

class ArtistsSourceMock: ArtistsSource {
    var pageSize: Int
    var error: Error?
    var delay: Int = 0
    var response: [ArtistsListModel.Artist]?
    var wasRequestCalled = false
    
    init(pageSize: Int = 10, error: Error? = nil, delay: Int = 0, response: [ArtistsListModel.Artist]? = nil) {
        self.pageSize = pageSize
        self.error = error
        self.delay = delay
        self.response = response
    }
    
    func artists(for _: String, page _: Int) -> AnyPublisher<[ArtistsListModel.Artist], Error> {
        wasRequestCalled = true
        if let error {
            return Fail(error: error)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        if let response {
            return Just(response)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: RequestsError.noMoreData)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func reduceCacheSize() {}
}

#endif
