//
//  APIEndpointProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import Foundation

protocol APIEndpointProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
}
