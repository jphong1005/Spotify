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
    private func performRequest<T: Codable>(query: String?, method: HTTPMethod?, params: Parameters? = nil, headers: HTTPHeaders? = nil) -> Observable<T> {
        
        return Observable.create { observser in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                if let query: String = query {
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
            }
            
            return Disposables.create()
        }.asObservable()
    }
    
    ///  PUBLIC, PRIVATE API Methods.
    ///
    /// Albums
    public func getAlbum(for album: CommonGroundModel.SimplifiedAlbum) -> Observable<Album> {
        
        return performRequest(query: "/albums/\(album.id)", method: .get)
    }
    
    public func getNewReleases() -> Observable<NewReleases> {
        
        return performRequest(query: "/browse/new-releases?limit=50", method: .get)
    }
    
    /// Categories
    public func getSeveralBrowseCategories() -> Observable<SeveralBrowseCategories> {
        
        return performRequest(query: "/browse/categories?limit=50", method: .get)
    }
    
    private func performGetSeveralBrowseCategories() async throws -> SeveralBrowseCategories {
        
        return try await withCheckedThrowingContinuation { continuation in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.defaultEndPoint +
                           "/browse/categories?limit=50",
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: SeveralBrowseCategories.self, queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let severalBrowseCategories):
                        continuation.resume(returning: severalBrowseCategories); break;
                    case .failure(let error):
                        continuation.resume(throwing: error); break;
                    }
                }
            }
        }
    }
    
    /// Genres
    private func getAvailableGenreSeeds() async throws -> Genre {
        
        /// .withCheckedThrowingContinuation()를 사용함으로써 비동기 코드 블록 내에서 값을 반환 or 오류를 던짐
        return try await withCheckedThrowingContinuation { continuation in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.defaultEndPoint + "/recommendations/available-genre-seeds",
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: Genre.self, queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let genre):
                        continuation.resume(returning: genre); break;
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        continuation.resume(throwing: error); break;
                    }
                }
            }
        }
    }
    
    /// Playlists
    public func getPlaylist(for playlist: CommonGroundModel.SimplifiedPlaylist) -> Observable<Playlist> {
        
        return performRequest(query: "/playlists/\(playlist.id)", method: .get)
    }
    
    public func getFeaturedPlaylists() -> Observable<Playlists> {
        
        return performRequest(query: "/browse/featured-playlists?limit=20", method: .get)
    }
    
    public func getCategoryPlaylists(args category: CommonGroundModel.Category) -> Task<Observable<Playlists>, Error> {
        
        /// Get Category's Playlists
        return Task(priority: .background) { () -> Observable<Playlists> in
            do {
                return performRequest(query: "/browse/categories/\(category.id)/playlists?limit=50", method: .get)
            } catch {
                throw error
            }
        }
    }
    
    /// Search
    public func searchForItem(args query: String) -> Observable<SearchResponse> {
        
        return performRequest(query: "/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=album,artist,playlist,track,show,episode,audiobook&limit=10", method: .get)
    }
    
    /// Tracks
    public func getRecommendations() -> Task<Observable<Recommendations>, Error> {
        
        return Task(priority: .background) { () -> Observable<Recommendations> in
            do {
                let genres: [String] = try await APICaller.shared.getAvailableGenreSeeds().genres
                var seeds: Set<String> = Set<String>()

                while seeds.count < 5 {
                    if let randomGenre: String = genres.randomElement() {
                        seeds.insert(randomGenre)
                    }
                }
                
                let seed_genres: String = seeds.joined(separator: ",")
                
                return performRequest(query: "/recommendations?limit=40&seed_genres=\(seed_genres)", method: .get)
            } catch {
                throw error
            }
        }
    }
    
    ///  Users
    public func getCurrentUserProfile() -> Observable<User> {
        
        return performRequest(query: "/me", method: .get)
    }
}
