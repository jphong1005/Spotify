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
    var featuredPlaylist: BehaviorSubject<FeaturedPlayListsResponse?> = BehaviorSubject(value: nil)
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getFeaturedPlaylists()
            .subscribe { [weak self] featuredPlaylist in
                self?.featuredPlaylist.onNext(featuredPlaylist)
            } onError: { error in
                self.featuredPlaylist.onError(error)
            }.disposed(by: self.bag)
    }
}
