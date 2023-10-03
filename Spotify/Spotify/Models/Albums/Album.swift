//
//  AlbumResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/24.
//

import Foundation

struct Album: Codable {
    
    // MARK: - Stored-Props
    let album_type: String
    let total_tracks: Int
    let available_markets: [String] = ["CA", "BR", "IT"]    //  ISO 3166-1 alpha-2 country code value
    let external_urls: CommonGround.ExternalURL
    let href: String
    let id: String
    let images: [CommonGround.`Image`]
    let name: String
    let release_date: String
    let release_date_precision: String
    //  let restrictions: CommonGround.Restriction = CommonGround.Restriction(reason: "")   //  market, product, explicit
    let type: String
    let uri: String
    let artists: [CommonGround.SimplifiedArtist]
    let tracks: Track
    let copyrights: [CommonGround.Copyright]
    let external_ids: CommonGround.ExternalID
    let genres: [String]
    let label: String
    let popularity: Int
    
    struct Track: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [SimplifiedTrack]
        
        struct SimplifiedTrack: Codable {
            
            // MARK: - Stored-Props
            let artists: [CommonGround.SimplifiedArtist]
            let available_markets: [String] = ["CA", "BR", "IT"]    //  ["CA", "BR", "IT"] -> ISO 3166-1 alpha-2 country code value
            let disc_number: Int
            let duration_ms: Int
            let explicit: Bool
            let external_urls: CommonGround.ExternalURL
            let href: String
            let id: String
            let is_playable: Bool
            let linked_from: CommonGround.LinkedFrom?
            //  let restrictions: CommonGround.Restriction = CommonGround.Restriction(reason: "")
            let name: String
            let preview_url: String?
            let track_number: Int
            let type: String
            let uri: String
            let is_local: Bool
        }
    }
}
