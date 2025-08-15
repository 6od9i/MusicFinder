//
//  AuthSettings.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Foundation

/// While there is not implemented OAuth, setup here your auth token from https://www.discogs.com/settings/developers
struct RequestsSettings {
    #warning("Put your token here")
    static let authToken = "your_token"

    static let defaultPageSize: Int = 30
}
