//
//  AuthManager.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation
import Alamofire

final class AuthManager {
    
    // MARK: - Singleton Instance
    static let shared: AuthManager = AuthManager()
    
    private let baseAuthURL: String = "https://accounts.spotify.com/authorize"
    private let scopes: String = "user-read-private"
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Computed-Props
    public var signInURL: URL? {
        
        let authorizationURL: String = "\(Auth.baseAuthURL)?" +
        "response_type=code" +
        "&client_id=\(Auth.client_ID.replacingOccurrences(of: "\"", with: ""))" +
        "&scope=\(Auth.scopes)" +
        "&redirect_uri=\(Auth.redirect_URI.replacingOccurrences(of: "\"", with: ""))" +
        "&show_dialog=TRUE"
        
        return URL(string: authorizationURL)
    }
    
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
    
    // MARK: - Methods
    public func exchangeCodeForAccessToken(code: String, completionHandler: @escaping (Bool) -> Void) -> Void {
        
        //  Get Access Token
    }
    
    public func refreshAccessToken() -> Void {
        
    }
    
    public func cacheAccessToken() -> Void {
        
    }
}
