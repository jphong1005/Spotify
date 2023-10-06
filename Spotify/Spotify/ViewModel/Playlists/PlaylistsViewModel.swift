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
    var featuredPlaylists: BehaviorSubject<Playlists?> = BehaviorSubject(value: nil)
    var categoryPlaylists: PublishSubject<Playlists>
    
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.playlist = PublishSubject<Playlist>.init()
        self.categoryPlaylists = PublishSubject<Playlists>.init()
        
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
    }
}
