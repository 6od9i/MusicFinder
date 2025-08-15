//
//  RequestsError.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Foundation

enum RequestsError: Error {
    case invalidURL
    case decodingFailed
    case noMoreData
    case emptyResponse
}
