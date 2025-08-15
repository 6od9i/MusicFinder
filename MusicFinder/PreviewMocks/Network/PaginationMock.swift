//
//  PaginationMock.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Foundation

#if DEBUG || TESTING

extension Pagination {
    static var mock: Pagination {
        Pagination(page: 1, pages: 3, perPage: 30, items: 90)
    }
}

#endif
