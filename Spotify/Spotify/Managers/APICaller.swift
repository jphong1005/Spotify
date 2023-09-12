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
    private static let defaultEndPoint: String = "https://api.spotify.com/v1"
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Methods
    //  PRIVATE Helper Method
    private func performRequest<T: Codable>(query: String, method: HTTPMethod, params: Parameters? = nil, headers: HTTPHeaders? = nil) -> Observable<T> {
        
        return Observable.create { observser in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.defaultEndPoint + query,
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: T.self,
                                   queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let data):
                        observser.onNext(data)
                        observser.onCompleted(); break;
                    case .failure(let error):
                        observser.onError(error); break;
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    //  PUBLIC API Methods
    public func getCurrentUserProfile() -> Observable<UserProfile> {
        
        return performRequest(query: "/me", method: .get)
    }
    
    public func getNewReleases() -> Observable<NewReleasesResponse> {
        
        return performRequest(query: "/browse/new-releases?limit=50", method: .get)
    }
}
