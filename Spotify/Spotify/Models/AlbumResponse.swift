//
//  AlbumResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/24.
//

import Foundation

struct AlbumResponse: Codable {
    
    // MARK: - Stored-Props
    let album_type: String
    let total_tracks: Int
    let available_markets: [String] = ["CA", "BR", "IT"]
    let external_urls: CommonGround.ExternalURLs
    let href: String
    let id: String
    let images: [CommonGround.`Image`]
    let name: String
    let release_date: String
    let release_date_precision: String
    //  let restrictions: CommonGround.Restriction = CommonGround.Restriction(reason: "")   //  market, product, explicit
    let type: String
    let uri: String
    //  let artists: CommonGround.SimplifiedArtist
    let tracks: Track
    let copyrights: [CommonGround.Copyright]
    let external_ids: CommonGround.ExternalIDs
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
        let items: [CommonGround.SimplifiedArtist]
    }
}
