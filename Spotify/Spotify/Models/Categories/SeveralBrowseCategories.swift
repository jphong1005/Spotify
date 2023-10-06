//
//  Categories.swift
//  Spotify
//
//  Created by 홍진표 on 10/4/23.
//

import Foundation

struct SeveralBrowseCategories: Codable {
    
    // MARK: - Stored-Prop
    let categories: Categories
    
    struct Categories: Codable {
        
        // MARK: - Stored-Props
        let href: String
        let limit: Int
        let next: String?
        let offset: Int
        let previous: String?
        let total: Int
        let items: [CommonGround.Category]
    }
}
