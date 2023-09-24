//
//  AudioTrack.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

struct Track: Codable {
    
    // MARK: - Stored-Props
    let album: CommonGround.SimplifiedAlbum
    let artists: [Artist]
    let available_markets: [String] //  ["CA", "BR", "IT"] -> ISO 3166-1 alpha-2 country code value
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_ids: CommonGround.ExternalIDs
    let external_urls: CommonGround.ExternalURLs
    let href: String
    let id: String
    //  let is_playable: Bool
    //  let linked_form: LinkedForm
    //  let restrictions: CommonGround.Restriction = CommonGround.Restriction(reason: "")   //  market, product, explicit
    let name: String
    let popularity: Int
    let preview_url: String?
    let track_number: Int
    let type: String
    let uri: String
    let is_local: Bool
    
    
    struct Artist: Codable {
        
        // MARK: - Stored-Props
        let external_urls: CommonGround.ExternalURLs
        //  let followers: CommonGround.Followers
        //  let genres: [String]
        let href: String
        let id: String
        //  let images: [CommonGround.`Image`]
        let name: String
        //  let popularity: Int
        let type: String
        let uri: String
    }
    
    struct LinkedForm: Codable {
        
        // MARK: - Stored-Props
        //  No Props
    }
}
