//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/14.
//

import Foundation

struct Recommendations: Codable {
    
    // MARK: - Stored-Props
    let seeds: [RecommendationSeed]
    let tracks: [TrackObject]
    
    struct RecommendationSeed: Codable {
        
        // MARK: - Stored-Props
        let afterFilteringSize: Int
        let afterRelinkingSize: Int
        let href: String?
        let id: String
        let initialPoolSize: Int
        let type: String
    }
}
