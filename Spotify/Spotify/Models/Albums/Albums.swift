//
//  SavedAlbums.swift
//  Spotify
//
//  Created by 홍진표 on 10/30/23.
//

import Foundation

struct Albums: Codable {
    
    // MARK: - Stored-Props
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SavedAlbumObject]
    
    struct SavedAlbumObject: Codable {
        
        // MARK: - Stored-Props
        let added_at: String
        let album: CommonGroundModel.SimplifiedAlbum
    }
}
