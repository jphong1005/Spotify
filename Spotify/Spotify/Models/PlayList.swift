//
//  PlayList.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

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
        let external_urls: CommonGround.ExternalURLs
        let href: String
        let id: String
        let images: [CommonGround.`Image`]
        let name: String
        let owner: CommonGround.Owner
        let primary_color: String?
        let `public`: Bool?
        let snapshot_id: String
        let tracks: Track
        let type: String
        //  let url: String
        
        struct Track: Codable {
            
            // MARK: - Stored-Props
            let href: String
            let total: Int
        }
    }
}
