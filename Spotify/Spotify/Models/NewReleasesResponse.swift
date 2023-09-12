//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/12.
//

import Foundation

struct NewReleasesResponse: Codable {
    
    // MARK: - Stored-Prop
    let albums: Album
    
    struct Album: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let items: [Item]
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        
        struct Item: Codable {
            
            // MARK: - Stored-Props
            let album_type: String
            let artists: [Artist]
            let external_urls: ItemExternalURLs
            let href: String
            let id: String
            let images: [`Image`]
            let is_playable: Bool
            let name: String
            let release_date: String
            let release_date_precision: String
            let total_tracks: Int
            let type: String
            let uri: String
            
            struct Artist: Codable {
                
                // MARK: - Stored-Props
                let external_urls: ArtistExternalURLs
                let href: String
                let id: String
                let name: String
                let type: String
                let uri: String
                
                struct ArtistExternalURLs: Codable {
                    
                    // MARK: - Stored-Prop
                    let spotify: String
                }
            }
            
            struct ItemExternalURLs: Codable {
                
                // MARK: - Stored-Prop
                let spotify: String
            }
            
            struct `Image`: Codable {
                
                // MARK: - Stored-Props
                let height: Int?
                let url: String
                let width: Int?
            }
        }
    }
}
