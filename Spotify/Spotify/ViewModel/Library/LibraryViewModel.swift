//
//  LibraryViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 10/23/23.
//

import Foundation
import RxSwift
import RxCocoa

final class LibraryViewModel {
    
    // MARK: - Stored-Props
    var playlists: BehaviorSubject<Playlists.Playlist?>
    var bag: DisposeBag
    
    // MARK: - Init
    init() {
        self.playlists = BehaviorSubject(value: nil)
        self.bag = DisposeBag()
        
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getCurrentUsersPlaylists()
            .subscribe { [weak self] playlist in
                self?.playlists.onNext(playlist)
            } onError: { error in
                self.playlists.onError(error)
            }.disposed(by: self.bag)
    }
}
