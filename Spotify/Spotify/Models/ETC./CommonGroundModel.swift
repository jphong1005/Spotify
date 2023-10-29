//
//  Artist.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

struct CommonGroundModel: Codable {
    
    struct ExternalURL: Codable {
        
        // MARK: - Stored-Prop
        let spotify: String
    }
    
    struct `Image`: Codable {
        
        // MARK: - Stored-Props
        let url: String
        let height: Int?
        let width: Int?
    }
    
    struct SimplifiedArtist: Codable {
        
        // MARK: - Stored-Props
        let external_urls: ExternalURL
        let href: String
        let id: String
        let name: String
        let type: String
        let uri: String
    }
    
    struct Restriction: Codable {
        
        // MARK: - Stored-Prop
        let reason: String
    }
    
    /// For NewReleases, Recommendations
    struct SimplifiedAlbum: Codable {
        
        // MARK: - Stored-Props
        let album_type: String
        let total_tracks: Int
        let available_markets: [String]?
        let external_urls: ExternalURL
        let href: String
        let id: String
        let images: [`Image`]
        let name: String
        let release_date: String
        let release_date_precision: String
        let restrictions: Restriction?
        let type: String
        let uri: String
        let artists: [SimplifiedArtist]
    }
    
    struct Follower: Codable {
        
        // MARK: - Stored-Props
        let href: String?
        let total: Int
    }
    
    struct ExternalID: Codable {
        
        // MARK: - Stored-Props
        let isrc: String?
        let ean: String?
        let upc: String?
    }
    
    struct Owner: Codable {
        
        // MARK: - Stored-Props
        let external_urls: ExternalURL
        let followers: Follower?
        let href: String
        let id: String
        let type: String
        let uri: String
        let display_name: String?
    }
    
    struct Copyright: Codable {
        
        // MARK: - Stored-Props
        let text: String
        let type: String
    }
    
    struct LinkedFrom: Codable {
        
        // MARK: - Stored-Props
        let external_urls: ExternalURL
        let href: String
        let id: String
        let type: String
        let uri: String
    }
    
    struct Category: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let icons: [`Image`]
        let id: String
        let name: String
    }
    
    struct ArtistObject: Codable {
        
        // MARK: - Stored-Props
        let external_urls: ExternalURL
        let followers: Follower?
        let genres: [String]?
        let href: String
        let id: String
        let images: [`Image`]?
        let name: String
        let popularity: Int?
        let type: String
        let uri: String
    }
    
    struct Album: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [SimplifiedAlbum]
    }
    
    struct SimplifiedPlaylist: Codable {
        
        // MARK: - Stored-Props
        let collaborative: Bool
        let description: String
        let external_urls: ExternalURL
        let followers: Follower?
        let href: String
        let id: String
        let images: [`Image`]
        let name: String
        let owner: Owner
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
    
    struct SimplifiedShow: Codable {
        
        // MARK: - Stored-Props
        let available_markets: [String]?
        let copyrights: [Copyright]
        let description: String
        let html_description: String
        let explicit: Bool
        let external_urls: ExternalURL
        let href: String
        let id: String
        let images: [`Image`]
        let is_externally_hosted: Bool
        let languages: [String]
        let media_type: String
        let name: String
        let publisher: String
        let type: String
        let uri: String
        let total_episodes: Int
    }
    
    struct SimplifiedEpisodeObject: Codable {
        
        // MARK: - Stored-Props
        let audio_preview_url: String?
        let description: String
        let html_description: String
        let duration_ms: Int
        let explicit: Bool
        let external_urls: ExternalURL
        let href: String
        let id: String
        let images: [`Image`]
        let is_externally_hosted: Bool
        let is_playable: Bool?
        let languages: [String]
        let name: String
        let release_date: String
        let release_date_precision: String
        let resume_point: ResumePoint?
        let type: String
        let uri: String
        let restrictions: Restriction?
        let show: SimplifiedShow?
        
        struct ResumePoint: Codable {
            
            // MARK: - Stored-Props
            let fully_played: Bool
            let resume_position_ms: Int
        }
    }
}
