//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/14.
//

import Foundation

struct NewReleases: Codable {
    
    // MARK: - Stored-Prop
    let albums: Album
    
    struct Album: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [CommonGround.SimplifiedAlbum]
    }
}
