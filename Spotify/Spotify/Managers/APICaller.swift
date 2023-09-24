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
    ///  PRIVATE Helper Method.
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
        }.asObservable()
    }
    
    ///  PUBLIC API Methods.
    public func getCurrentUserProfile() -> Observable<UserProfile> {
        
        return performRequest(query: "/me", method: .get)
    }
    
    public func getNewReleases() -> Observable<NewReleasesResponse> {
        
        /// limit -> default: 20, range: 0 ~ 50
        /// offset -> default: 0
        return performRequest(query: "/browse/new-releases?limit=50", method: .get)
    }
    
    public func getFeaturedPlaylists() -> Observable<FeaturedPlayListsResponse> {
        
        /// limit -> default: 20, range: 0 ~ 50
        /// offset -> default: 0
        return performRequest(query: "/browse/featured-playlists?limit=20", method: .get)
    }
    
    public func getAvailableGenreSeeds() async throws -> GenreResponse {
        
        //  .withCheckedThrowingContinuation()를 사용함으로써 비동기 코드 블록 내에서 값을 반환 or 오류를 던짐
        return try await withCheckedThrowingContinuation({ continuation in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.defaultEndPoint + "/recommendations/available-genre-seeds",
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: GenreResponse.self, queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let genreResponse):
                        continuation.resume(returning: genreResponse); break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        continuation.resume(throwing: error); break;
                    }
                }
            }
        })
    }
    
    public func getRecommendations(genres: Set<String>) -> Observable<RecommendationsResponse> {

        let seeds: String = genres.joined(separator: ",")
        
        //  limit -> default: 20, range: 1 ~ 100
        return performRequest(query: "/recommendations?limit=40&seed_genres=\(seeds)", method: .get)
    }
    
    public func performGetRecommendations() -> Task<Observable<RecommendationsResponse>, Error> {
        
        return Task(priority: .background) { () -> Observable<RecommendationsResponse> in
            do {
                let genres: [String] = try await APICaller.shared.getAvailableGenreSeeds().genres
                var seeds: Set<String> = Set<String>()

                while seeds.count < 5 {
                    if let randomGenre: String = genres.randomElement() {
                        seeds.insert(randomGenre)
                    }
                }

                return getRecommendations(genres: seeds)
            } catch {
                throw error
            }
        }
    }
    
    public func getAlbum(for album: NewReleasesResponse.Album.SimplifiedAlbum) -> Void {
        
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = HTTPHeaders([
                "Authorization": "Bearer \(token)"
            ])
            
            AF.request(APICaller.defaultEndPoint + "/albums/\(album.id)",
                       method: .get,
                       headers: headers)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .response(queue: DispatchQueue.global(qos: .background)) { response in
                switch response.result {
                case .success(let data):
                    do {
                        let data: AlbumResponse = try JSONDecoder().decode(AlbumResponse.self, from: data ?? Data())
                        print(data)
                    } catch {
                        print(error.localizedDescription)
                    }
                    break;
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func getPlaylist(for playlist: PlayList.SimplifiedPlaylist) -> Void {
        
        AuthManager.shared.withValidToken { token in
            let headers: HTTPHeaders = HTTPHeaders([
                "Authorization": "Bearer \(token)"
            ])
            
            AF.request(APICaller.defaultEndPoint + "/playlists/\(playlist.id)",
                       method: .get,
                       headers: headers)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .response(queue: DispatchQueue.global(qos: .background)) { response in
                switch response.result {
                case .success(let data):
                    do {
                        let data: PlaylistResponse = try JSONDecoder().decode(PlaylistResponse.self, from: data ?? Data())
                        print(data)
                    } catch {
                        print(error.localizedDescription)
                    }
                    break;
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
