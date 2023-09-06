//
//  Auth.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/02.
//

import Foundation

struct Auth {
    
    // MARK: - Stored-Props
    static let client_ID: String = Auth.loadSpotifyInfo()["Client_ID"] ?? ""
    static let client_secret: String = Auth.loadSpotifyInfo()["Client_secret"] ?? ""
    static let redirect_URI: String = "spotify://"
    static let accessToken_API_URL: String = "https://accounts.spotify.com/api/token"
    
    static let baseAuthURL: String = "https://accounts.spotify.com/authorize"
    static let scopes: String = "user-read-private"
    
    // MARK: - Method
    private static func loadSpotifyInfo() -> [String : String] {
        
        //  Info.plist의 path 찾기
        if let plistPath: String = Bundle.main.path(forResource: "Info", ofType: "plist") {
            do {
                if #available(iOS 16.0, *) {
                    //  Info.plist 데이터 읽어오기
                    let plistData = try Data(contentsOf: URL(filePath: plistPath))
                    
                    //  Data를 parsing하여 Dictionary로 변환
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String : Any] {
                        
                        //  Dictionary return
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            
                            return value
                        }
                    }
                } else {
                    let plistData = try Data(contentsOf: URL(fileReferenceLiteralResourceName: plistPath))
                    
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [],format: nil) as? [String : Any] {
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            
                            return value
                        }
                    }
                }
            } catch {
                print("error: \(error.localizedDescription)")
                fatalError(error.localizedDescription)
            }
        }
        
        return [:]
    }
}
