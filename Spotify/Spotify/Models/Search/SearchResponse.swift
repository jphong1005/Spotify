//
//  SearchResponse.swift
//  Spotify
//
//  Created by 홍진표 on 10/7/23.
//

import Foundation

struct SearchResponse: Codable {
    
    // MARK: - Stored-Props
    let tracks: Track?
    let artists: Artist?
    let albums: CommonGroundModel.Album?
    let playlists: Playlists.Playlist?
    let shows: Show?
    let episodes: Episode?
    let audiobooks: Audiobook?
    
    struct Track: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [TrackObject]
    }
    
    struct Artist: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [CommonGroundModel.ArtistObject]
    }
    
    struct Show: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [CommonGroundModel.SimplifiedShow]
    }
    
    struct Episode: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [CommonGroundModel.SimplifiedEpisodeObject]
    }
    
    struct Audiobook: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [SimplifiedAudiobookObject]
        
        struct SimplifiedAudiobookObject: Codable {
            
            // MARK: - Stored-Props
            let authors: [AuthorObject]
            let available_markets: [String]?
            let copyrights: [CommonGroundModel.Copyright]
            let description: String
            let html_description: String
            let edition: String
            let explicit: String
            let external_urls: CommonGroundModel.ExternalURL
            let href: String
            let id: String
            let images: [CommonGroundModel.`Image`]
            let languages: [String]
            let media_type: String
            let name: String
            let narrators: [NarratorObject]
            let publisher: String
            let type: String
            let uri: String
            let total_chapters: Int
            
            struct AuthorObject: Codable {
                
                // MARK: - Stored-Prop
                let name: String
            }
            
            struct NarratorObject: Codable {
                
                // MARK: - Stored-Prop
                let name: String
            }
        }
    }
}
