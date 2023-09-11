//
//  APICaller.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class APICaller {
    
    // MARK: - Singleton Instance
    static let shared: APICaller = APICaller()
    
    // MARK: - Static constant
    private static let endPoint: String = "https://api.spotify.com/v1"
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Methods
    public func getCurrentUserProfile() -> Observable<UserProfile> {
        
        return Observable.create { observer in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.endPoint + "/me",
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: UserProfile.self, queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let userProfile):
                        print("userProfile: \(userProfile) \n")
                        observer.onNext(userProfile)
                        observer.onCompleted()
                        break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error)
                        break;
                    }
                }
            }
            
            return Disposables.create()
        }.asObservable()
    }
}
