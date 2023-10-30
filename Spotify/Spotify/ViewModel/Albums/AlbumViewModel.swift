//
//  AlbumViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 9/29/23.
//

import Foundation
import RxSwift
import RxCocoa

final class AlbumViewModel {
    
    // MARK: - Stored-Props
    var album: PublishSubject<Album>
    var getUsersSavedAlbums: BehaviorSubject<Albums?>
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.album = PublishSubject<Album>.init()
        self.getUsersSavedAlbums = BehaviorSubject(value: nil)
        
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getUsersSavedAlbums()
            .subscribe { [weak self] albums in
                self?.getUsersSavedAlbums.onNext(albums)
            } onError: { error in
                self.getUsersSavedAlbums.onError(error)
            }.disposed(by: self.bag)
    }
}
