//
//  PlaylistResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/24.
//

import Foundation

struct Playlist: Codable {
    
    // MARK: - Stored-Props
    let collaborative: Bool
    let description: String?
    let external_urls: CommonGroundModel.ExternalURL
    //  let followers: CommonGround.Follower
    let href: String
    let id: String
    let images: [CommonGroundModel.`Image`]
    let name: String
    let owner: CommonGroundModel.Owner
    let `public`: Bool
    let snapshot_id: String
    let tracks: Track
    let type: String
    let uri: String
    
    struct Track: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [PlaylistTrack]
        
        struct PlaylistTrack: Codable {
            
            // MARK: - Stored-Props
            let added_at: String
            let added_by: AddedBy
            let is_local: Bool
            let track: TrackObject
            
            struct AddedBy: Codable {
                
                // MARK: - Stored-Props
                let external_urls: CommonGroundModel.ExternalURL
                //  let followers: CommonGround.Follower
                let href: String
                let id: String
                let type: String
                let uri: String
            }
        }
    }
}
