//
//  APIMock.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
@testable import MusicFinder

struct APIMock: APIEndpointProtocol {
    var path: String = "https://example.com"
    var method: MusicFinder.HTTPMethod = .get
    var headers: [String : String] = [:]
}
