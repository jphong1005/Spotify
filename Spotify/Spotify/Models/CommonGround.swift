//
//  Artist.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

struct CommonGround: Codable {
    
    struct ExternalURLs: Codable {
        
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
        let external_urls: ExternalURLs
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
    
    struct SimplifiedAlbum: Codable {
        
        // MARK: - Stored-Props
        let album_type: String
        let total_tracks: Int
        let available_markets: [String] = ["CA", "BR", "IT"]    //  ISO 3166-1 alpha-2 country code value
        let external_urls: ExternalURLs
        let href: String
        let id: String
        let images: [`Image`]
        let name: String
        let release_date: String
        let release_date_precision: String
        //  let restrictions: CommonGround.Restriction = CommonGround.Restriction(reason: "")   //  market, product, explicit
        let type: String
        let uri: String
        let artists: [SimplifiedArtist]
    }
    
    struct Followers: Codable {
        
        // MARK: - Stored-Props
        let href: String?
        let total: Int
    }
}
