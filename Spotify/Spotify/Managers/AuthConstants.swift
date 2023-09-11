//
//  Auth.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/02.
//

import Foundation

struct AuthConstants {
    
    // MARK: - Stored-Props
    static let strClient_ID: String = AuthConstants.loadSpotifyInfo()["Client_ID"] ?? ""
    static let strClient_secret: String = AuthConstants.loadSpotifyInfo()["Client_secret"] ?? ""
    static let strRedirect_URI: String = "https://www.spotify.com"
    static let strToken_URL: String = "https://accounts.spotify.com/api/token"
    
    static let strBaseAuthURL: String = "https://accounts.spotify.com/authorize"
    static let scopes = returnScopes(arg: dictListOfScopes)
    
    private static let dictListOfScopes: [String : [String]] = [
        "Playlists": ["playlist-read-private", "playlist-modify-private", "playlist-modify-public"],
        "Follow": ["user-follow-read"],
        "Library": ["user-library-modify", "user-library-read"],
        "Users": ["user-read-email", "user-read-private"]
    ]
    
    // MARK: - Methods
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
    
    //  List of Scopes (-> Query)
    private static func returnScopes(arg params: [String: [String]]) -> String {
        
        var strVal: [String] = [String]()
        
        for (_, value) in params {
            strVal += value
        }
        
        let combinedStr: String = strVal.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return combinedStr
    }
}
