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
    let available_markets: [String]?
    let external_urls: CommonGroundModel.ExternalURL
    let href: String
    let id: String
    let images: [CommonGroundModel.`Image`]
    let name: String
    let release_date: String
    let release_date_precision: String
    let restrictions: CommonGroundModel.Restriction?
    let type: String
    let uri: String
    let artists: [CommonGroundModel.SimplifiedArtist]
    let tracks: CommonGroundModel.Track
    let copyrights: [CommonGroundModel.Copyright]
    let external_ids: CommonGroundModel.ExternalID
    let genres: [String]
    let label: String
    let popularity: Int
}
