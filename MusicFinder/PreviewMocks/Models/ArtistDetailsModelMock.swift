//
//  ArtistDetailsModelMock.swift
//  MusicFinderTests
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING
extension ArtistDetailsModel {
    static func mock(
        id: Int = 0,
        name: String = "Artist mock",
        profile: String? = "Lorem ipsum dolor sit amet",
        realname: String? = "Real Name",
        images: [Image]? = [
            .init(type: .secondary,
                  uri: "https://i.discogs.com/VEIq9lMkVhBtzJXnmqHmJF0o0CoQ70pdRYTRabQ9MAE/rs:fit/g:sm/q:90/h:450/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTI3NTEx/OC0xNjQ1Mzg2NTU1/LTc5ODQuanBlZw.jpeg"),
            .init(type: .primary,
                  uri: "https://i.discogs.com/BM_ii7giuZNNSTo_0fdL3XoeqCmAP_gn6X3hZxbht1U/rs:fit/g:sm/q:90/h:600/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTI3NTEx/OC0xNjQ0MDk4OTIx/LTE5NjUuanBlZw.jpeg")
        ],
        members: [Artist]? = [.mock, .mock, .mock],
        groups: [Group]? = [.mock, .mock, .mock]) -> ArtistDetailsModel {
        ArtistDetailsModel(
            id: id,
            name: name,
            profile: profile,
            realname: realname,
            images: images,
            members: members,
            groups: groups
        )
    }
}

extension ArtistDetailsModel.Artist {
    static var mock: ArtistDetailsModel.Artist {
        .init(
            id: ArtistsListModel.Artist.mock.id,
            name: ArtistsListModel.Artist.mock.name,
            active: true,
            thumbnail: ArtistsListModel.Artist.mock.thumbnail
        )
    }
}

extension ArtistDetailsModel.Group {
    static var mock: ArtistDetailsModel.Group {
        .init(
            id: 202,
            name: "Group Name",
            active: true,
            thumbnail: "https://i.discogs.com/rCogM6Wp2G1xxH-Ye0USfD_ClyeNqZolBNfjdLOO2ZA/rs:fit/g:sm/q:40/h:609/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTEyNTI0/Ni0xNTAxMjg1MjAw/LTMwNTguanBlZw.jpeg"
        )
    }
}
#endif
