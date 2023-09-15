//
//  FeaturedPlayListsResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/14.
//

import Foundation

struct FeaturedPlayListsResponse: Codable {
    
    // MARK: - Stored-Props
    let message: String
    let playlists: PlayList
}
