//
//  UserProfile.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

struct User: Codable {
    
    // MARK: - Stored-Props
    let country: String
    let display_name: String
    let email: String
    let explicit_content: ExplicitContent
    let external_urls: CommonGroundModel.ExternalURL
    //  let followers: CommonGround.Follower
    let href: String
    let id: String
    let images: [CommonGroundModel.`Image`]
    let product: String
    let type: String
    let uri: String
    
    struct ExplicitContent: Codable {
        
        // MARK: - Stored-Props
        let filter_enabled: Bool
        let filter_locked: Bool
    }
}
