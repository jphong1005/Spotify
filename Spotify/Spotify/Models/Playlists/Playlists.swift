//
//  FeaturedPlayListsResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/14.
//

import Foundation

struct Playlists: Codable {
    
    // MARK: - Stored-Props
    let message: String?
    let playlists: Playlist
    
    struct Playlist: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [CommonGroundModel.SimplifiedPlaylist?]
    }
}
