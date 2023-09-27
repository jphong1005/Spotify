//
//  FeaturedPlayListsResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/14.
//

import Foundation

struct FeaturedPlaylists: Codable {
    
    // MARK: - Stored-Props
    let message: String
    let playlists: PlayList
    
    struct PlayList: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [SimplifiedPlaylist]
        
        struct SimplifiedPlaylist: Codable {
            
            // MARK: - Stored-Props
            let collaborative: Bool
            let description: String
            let external_urls: CommonGround.ExternalURL
            let href: String
            let id: String
            let images: [CommonGround.`Image`]
            let name: String
            let owner: CommonGround.Owner
            let `public`: Bool?
            let snapshot_id: String
            let tracks: Track
            let type: String
            let uri: String
            
            struct Track: Codable {
                
                // MARK: - Stored-Props
                let href: String
                let total: Int
            }
        }
    }
}
