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
    public func getCurrentUserProfile() -> Observable<UserProfile> {
        
        return Observable.create { observer in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.defaultEndPoint + "/me",
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: UserProfile.self, queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let userProfile):
                        dump("\(userProfile) \n")
                        observer.onNext(userProfile)
                        observer.onCompleted(); break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error); break;
                    }
                }
            }
            
            return Disposables.create()
        }.asObservable()
    }
    
    public func getNewReleases() -> Observable<NewReleasesResponse> {
        
        return Observable.create { observer in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                print(token)
                print("?: \(headers)")
                
                AF.request(APICaller.defaultEndPoint + "/browse/new-releases?limit=50",
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: NewReleasesResponse.self, queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let newRelease):
                            dump("\(newRelease) \n")
                            observer.onNext(newRelease)
                            observer.onCompleted(); break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        observer.onError(error); break;
                    }
                }
            }
            
            return Disposables.create()
        }.asObservable()
    }
}
