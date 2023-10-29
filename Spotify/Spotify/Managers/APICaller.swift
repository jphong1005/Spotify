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
    // MARK: - PRIVATE Helper Method.
    private func performRequest<T: Codable>(query: String?, method: HTTPMethod?, params: Parameters? = nil, headers: HTTPHeaders? = nil) -> Observable<T> {
        
        return Observable.create { observser in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                guard let query: String = query else { return }
                
                AF.request(APICaller.defaultEndPoint + query,
                           method: .get,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: T.self, queue: DispatchQueue.global(qos: .background)) { response in
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
    
    // MARK: - PUBLIC, PRIVATE API Methods.
    // MARK: - Albums
    public func getAlbum(for album: CommonGroundModel.SimplifiedAlbum) -> Observable<Album> {
        
        return performRequest(query: "/albums/\(album.id)", method: .get)
    }
    
    public func getNewReleases() -> Observable<NewReleases> {
        
        return performRequest(query: "/browse/new-releases?limit=50", method: .get)
    }
    
    // MARK: - Categories
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
    
    // MARK: - Genres
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
    
    // MARK: - Playlists
    public func getPlaylist(for playlist: CommonGroundModel.SimplifiedPlaylist) -> Observable<Playlist> {
        
        return performRequest(query: "/playlists/\(playlist.id)", method: .get)
    }
    
    
    public func addItemsToPlaylist(first_args track: TrackObject, second_args playlist: CommonGroundModel.SimplifiedPlaylist) -> Observable<Void> {
        
        let body_param: Parameters = [
            "uris": ["spotify:track:\(track.id)"]
        ]
        
        return Observable.create { observer in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.defaultEndPoint + "/playlists/\(playlist.id)/tracks",
                           method: .post,
                           parameters: body_param,
                           encoding: JSONEncoding.default,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .response(queue: DispatchQueue.global(qos: .background)) { reponse in
                    switch reponse.result {
                    case .success(let data):
                        do {
                            guard let safeData: Data = data else { return }
                            
                            let data: Any = try JSONSerialization.jsonObject(with: safeData, options: .fragmentsAllowed)
                            if let uris: [String : Any] = data as? [String: Any], uris["snapshot_id"] as? String != nil {
                                print("uris: \(uris)")
                                
                                observer.onNext(())
                                observer.onCompleted(); break;
                            }
                        } catch {
                            print("error: \(error.localizedDescription)")
                        }
                        break;
                    case .failure(let error):
                        observer.onError(error); break;
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func getCurrentUsersPlaylists() -> Observable<Playlists.Playlist> {
        
        return performRequest(query: "/me/playlists?limit=50", method: .get)
    }
    
    public func createPlaylist(args playlistName: String) -> Observable<Void> {
        
        let body_params: Parameters = [
            "name": playlistName
        ]
        
        /// 값을 emits 할 필요가 없기 때문에, 값이 없는 Sequence만 생성함.
        return Observable.create { observer in
            AuthManager.shared.withValidToken { token in
                let headers: HTTPHeaders = HTTPHeaders([
                    "Authorization": "Bearer \(token)"
                ])
                
                AF.request(APICaller.defaultEndPoint + "/me",
                           method: .get,
                           encoding: JSONEncoding.default,
                           headers: headers)
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: User.self, queue: DispatchQueue.global(qos: .background)) { response in
                    switch response.result {
                    case .success(let data):
                        AF.request(APICaller.defaultEndPoint + "/users/\(data.id)/playlists",
                                   method: .post,
                                   parameters: body_params,
                                   encoding: JSONEncoding.default,
                                   headers: headers)
                        .validate(statusCode: 200 ..< 300)
                        .validate(contentType: ["application/json"])
                        .responseDecodable(of: Playlist.self, queue: DispatchQueue.global(qos: .background)) { response in
                            switch response.result {
                            case .success(let data):
                                
                                /// Create Playlist Data 로그 출력
                                dump(data)
                                
                                observer.onNext(())
                                observer.onCompleted(); break;
                            case .failure(let error):
                                observer.onError(error); break;
                            }
                        }
                        break;
                    case .failure(let error):
                        observer.onError(error); break;
                    }
                }
            }
            
            return Disposables.create()
        }
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
    
    // MARK: - Search
    public func searchForItem(args query: String) -> Observable<SearchResponse> {
        
        return performRequest(query: "/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=album,artist,playlist,track,show,episode,audiobook&limit=10", method: .get)
    }
    
    // MARK: - Tracks
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
    
    // MARK: - Users
    public func getCurrentUserProfile() -> Observable<User> {
        
        return performRequest(query: "/me", method: .get)
    }
}
