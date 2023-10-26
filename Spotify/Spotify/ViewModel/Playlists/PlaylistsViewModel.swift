//
//  PlaylistsViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/16.
//

import Foundation
import RxSwift
import RxCocoa

final class PlaylistsViewModel {
    
    // MARK: - Stored-Props
    var playlist: PublishSubject<Playlist>
    var featuredPlaylists: BehaviorSubject<Playlists?>
    var categoryPlaylists: PublishSubject<Playlists>
    var getCurrentUsersPlaylists: BehaviorSubject<Playlists.Playlist?>
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.playlist = PublishSubject<Playlist>.init()
        self.featuredPlaylists = BehaviorSubject(value: nil)
        self.categoryPlaylists = PublishSubject<Playlists>.init()
        self.getCurrentUsersPlaylists = BehaviorSubject(value: nil)
        
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getFeaturedPlaylists()
            .subscribe { [weak self] featuredPlaylist in
                self?.featuredPlaylists.onNext(featuredPlaylist)
            } onError: { error in
                self.featuredPlaylists.onError(error)
            }.disposed(by: self.bag)
        
        APICaller.shared.getCurrentUsersPlaylists()
            .subscribe { [weak self] playlist in
                self?.getCurrentUsersPlaylists.onNext(playlist)
            } onError: { error in
                self.getCurrentUsersPlaylists.onError(error)
            }.disposed(by: self.bag)
    }
}
