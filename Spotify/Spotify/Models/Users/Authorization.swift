//
//  AuthResponse.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/05.
//

import Foundation

struct Authorization: Codable {
    
    // MARK: - Stored-Props
    let refresh_token: String?
    let scope: String
    let expires_in: Int
    let token_type: String
    let access_token: String
}
