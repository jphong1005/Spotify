//
//  SearchViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 10/8/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    // MARK: - Stored-Props
    var search: PublishSubject<SearchResponse>
    var searchResults: PublishSubject<[SearchResult]>
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.search = PublishSubject<SearchResponse>.init()
        self.searchResults = PublishSubject<[SearchResult]>.init()
    }
}
