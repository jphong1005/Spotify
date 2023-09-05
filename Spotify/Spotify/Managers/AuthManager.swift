//
//  AuthManager.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation
import Alamofire
import Security
import KeychainAccess

final class AuthManager {
    
    // MARK: - Singleton Instance
    static let shared: AuthManager = AuthManager()
    
    // MARK: - Stored-Props
    private static let serviceName: String = Bundle.main.bundleIdentifier ?? "UNKOWN VALUE"
    private let keychain: Keychain = Keychain(service: serviceName)
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Computed-Props
    public var signInURL: URL? {
        
        let authorizationURL: String = "\(Auth.baseAuthURL)?" +
        "response_type=code" +
        "&client_id=\(Auth.client_ID)" +
        "&scope=\(Auth.scopes)" +
        "&redirect_uri=\(Auth.redirect_URI)" +
        "&show_dialog=TRUE"
        
        return URL(string: authorizationURL)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return try? keychain.get("access_token")
    }
    
    private var refreshToken: String? {
        return try? keychain.get("refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return try? keychain.get("expiration_date") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate: Date = Date()
        let minuate: TimeInterval = 60
        
        return currentDate.addingTimeInterval(minuate * 5) >= expirationDate
    }
    
    // MARK: - Methods
    public func exchangeCodeForAccessToken(code: String, completionHandler: @escaping (Bool) -> Void) -> Void {
        
        //  Get Access Token
        guard let url: URL = URL(string: Auth.accessToken_API_URL) else { return }
        
        //  Header-Params
        let headerParams: HTTPHeaders = [
            "Authorization": "Basic \(translate(id: Auth.client_ID, secret: Auth.client_secret))",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        //  Body-Params
        let bodyParams: [String : Any] = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Auth.redirect_URI
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: bodyParams,
                   headers: headerParams)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: AuthResponse.self, queue: DispatchQueue.global(qos: .background)) { [weak self] response in
            switch response.result {
            case .success(let authResponse):
                print("authResponse: \(authResponse) \n")
                
                self?.cacheAccessToken(with: authResponse)
                break;
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                fatalError(error.localizedDescription)
            }
        }
    }
    
    //  To String (-> 'base64')
    private func translate(id: String, secret: String) -> String {
        
        let str: String = "\(id):\(secret)"
        guard let data: Data = str.data(using: .utf8) else { return "UNKOWN VALUE" }
        
        return data.base64EncodedString()
    }

    public func cacheAccessToken(with result: AuthResponse) -> Void {
        
        //  Access Token의 경우 민감한 정보이기 때문에 UserDefaults가 아닌 Keychain Service를 사용!
        guard let refresh_token: String = result.refresh_token else { return }
        let access_token: String = result.access_token
        
        // MARK: - ver. Security (-> import Security)
        /*
        //  Access_Token을 utf-8 형식의 Data로 변환
        if let data = access_token.data(using: .utf8) {
            
            //  Keychain에 저장하기 위해 query 생성
            let query: [CFString : Any] = [
                kSecClass: kSecClassGenericPassword,    //  Keychain item class 지정 (-> 일반적으로 pw 또는 token 저장에 사용)
                kSecAttrService: serviceName,   //  serviceName을 지정해 Keychain item을 식별
                kSecAttrAccount: access_token,  //  계정이름 or 키를 지정해 Keychain item을 식별
                kSecValueData: data //  Keychain에 저장할 data를 설정
            ]
            
            //  Keychain에 data 추가
            let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
            
            //  data 추가 작업이 성공하지 않을 경우 error
            if (status != errSecSuccess) {
                print("Error saving access token to Keychain")
            }
        }
         */
        
        // MARK: - ver. KeychainAccess
        do {
            try keychain.set(access_token, key: "access_token")
            try keychain.set(refresh_token, key: "refresh_token")
            try keychain.set("\(Date().addingTimeInterval(TimeInterval(result.expires_in)))", key: "expiration_date")
        } catch (let error) {
            print("keychain error: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
    }
    
    public func obtainingAnItem() -> Void {
        
    }
    
    public func refreshAccessToken() -> Void {
        
    }
}
