//
//  Auth.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/02.
//

import Foundation

struct Auth {
    
    // MARK: - Stored-Props
    static let client_ID: String = Auth.loadClient_ID() ?? ""
    static let client_secret: String = Auth.loadClient_secret() ?? ""
    static let redirect_URI: String = Auth.loadRedirect_URI() ?? ""
    
    static let baseAuthURL: String = "https://accounts.spotify.com/authorize"
    static let scopes: String = "user-read-private"
    
    // MARK: - Methods
    private static func loadClient_ID() -> String? {
        
        //  Info.plist의 path 찾기
        if let plistPath: String = Bundle.main.path(forResource: "Info", ofType: "plist") {
            do {
                //  Info.plist 데이터 읽어오기
                if #available(iOS 16.0, *) {
                    let plistData = try Data(contentsOf: URL(filePath: plistPath))
                    
                    //  Data를 parsing하여 Dictionary로 변환
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [],format: nil) as? [String : Any] {

                        //  Key-Value 가져오고 return
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            return value["Client_ID"] ?? "Unkown Value"
                        }
                    }
                } else {
                    let plistData = try Data(contentsOf: URL(fileReferenceLiteralResourceName: plistPath))
                    
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [],format: nil) as? [String : Any] {
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            return value["Client_ID"] ?? "Unkown Value"
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    private static func loadClient_secret() -> String? {
        
        if let plistPath: String = Bundle.main.path(forResource: "Info", ofType: "plist") {
            do {
                if #available(iOS 16.0, *) {
                    let plistData = try Data(contentsOf: URL(filePath: plistPath))
                    
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [],format: nil) as? [String : Any] {
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            return value["Client_secret"] ?? "Unkown Value"
                        }
                    }
                } else {
                    let plistData = try Data(contentsOf: URL(fileReferenceLiteralResourceName: plistPath))
                    
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [],format: nil) as? [String : Any] {
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            return value["Client_secret"] ?? "Unkown Value"
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    private static func loadRedirect_URI() -> String? {
        
        if let plistPath: String = Bundle.main.path(forResource: "Info", ofType: "plist") {
            do {
                if #available(iOS 16.0, *) {
                    let plistData = try Data(contentsOf: URL(filePath: plistPath))
                    
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [],format: nil) as? [String : Any] {
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            return value["Redirect_URI"] ?? "Unkown Value"
                        }
                    }
                } else {
                    let plistData = try Data(contentsOf: URL(fileReferenceLiteralResourceName: plistPath))
                    
                    if let plistDictionary: [String : Any] = try PropertyListSerialization.propertyList(from: plistData, options: [],format: nil) as? [String : Any] {
                        if let value: [String : String] = plistDictionary["Spotify"] as? [String : String] {
                            return value["Redirect_URI"] ?? "Unkown Value"
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
}
