//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/14.
//

import Foundation

struct RecommendationsResponse: Codable {
    
    // MARK: - Stored-Props
    let seeds: [Seed]
    let tracks: [Track]
    
    struct Seed: Codable {
        
        // MARK: - Stored-Props
        let afterFilteringSize: Int
        let afterRelinkingSize: Int
        let href: String?
        let id: String
        let initialPoolSize: Int
        let type: String
    }
}
