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
    let external_urls: CommonGround.ExternalURL
    //  let followers: CommonGround.Follower
    let href: String
    let id: String
    let images: [CommonGround.`Image`]
    let name: String
    let owner: CommonGround.Owner
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
                let external_urls: CommonGround.ExternalURL
                //  let followers: CommonGround.Follower
                let href: String
                let id: String
                let type: String
                let uri: String
            }
            
            struct EpisodeObject: Codable {
                
                // MARK: - Stored-Props
                let audio_preview_url: String?
                let description: String
                let html_description: String
                let duration_ms: Int
                let explicit: Bool
                let external_urls: CommonGround.ExternalURL
                let href: String
                let id: String
                let images: [CommonGround.`Image`]
                let is_externally_hosted: Bool
                let is_playable: Bool
                let languages: [String]
                let name: String
                let release_date: String
                let release_date_precision: String
                let resume_point: ResumePoint
                let type: String
                let uri: String
                //  let restrictions: CommonGround.Restriction = CommonGround.Restriction(reason: "")   //  market, product, explicit
                let show: Show
                
                struct ResumePoint: Codable {
                    
                    // MARK: - Stored-Props
                    let fully_played: Bool
                    let resume_position_ms: Int
                }
                
                struct Show: Codable {
                    
                    // MARK: - Stored-Props
                    let available_markets: [String]
                    let copyrights: [CommonGround.Copyright]
                    let description: String
                    let html_description: String
                    let explicit: Bool
                    let external_urls: CommonGround.ExternalURL
                    let href: String
                    let id: String
                    let images: [CommonGround.`Image`]
                    let is_externally_hosted: Bool
                    let languages: [String]
                    let media_type: String
                    let name: String
                    let publisher: String
                    let type: String
                    let uri: String
                    let total_episodes: Int
                }
            }
        }
    }
}
