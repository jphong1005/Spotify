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
    
    // MARK: - Stored-Prop
    var album: PublishSubject<Album>
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.album = PublishSubject<Album>.init()
    }
}
