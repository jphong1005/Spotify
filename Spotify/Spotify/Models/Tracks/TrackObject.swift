//
//  AudioTrack.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

/// For Recommendations - tracks
struct TrackObject: Codable {
    
    // MARK: - Stored-Props
    let album: Album
    let artists: [CommonGroundModel.ArtistObject]
    let available_markets: [String]?
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_ids: CommonGroundModel.ExternalID
    let external_urls: CommonGroundModel.ExternalURL
    let href: String
    let id: String
    let is_playable: Bool?
    let linked_from: CommonGroundModel.LinkedFrom?
    let restrictions: CommonGroundModel.Restriction?
    let name: String
    let popularity: Int
    let preview_url: String?
    let track_number: Int
    let type: String
    let uri: String
    let is_local: Bool
    
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
        let release_date: String?
        let release_date_precision: String?
        let restrictions: CommonGroundModel.Restriction?
        let type: String
        let uri: String
        let artists: [CommonGroundModel.SimplifiedArtist]
    }
}
