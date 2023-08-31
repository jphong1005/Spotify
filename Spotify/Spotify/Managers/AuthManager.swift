//
//  AuthManager.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation

final class AuthManager {
    
    // MARK: - Singleton Instance
    static let shared: AuthManager = AuthManager()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Computed-Props
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
