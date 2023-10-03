//
//  Artist.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

struct CommonGround: Codable {
    
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
        let available_markets: [String] = ["CA", "BR", "IT"]    //  ISO 3166-1 alpha-2 country code value
        let external_urls: ExternalURL
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
        //  let followers: Follower
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
}
