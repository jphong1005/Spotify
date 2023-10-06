//
//  CategoriesViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 10/5/23.
//

import Foundation
import RxSwift
import RxCocoa

final class CategoriesViewModel {
    
    // MARK: - Stored-Props
    var categories: BehaviorSubject<SeveralBrowseCategories?> = BehaviorSubject(value: nil)
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getSeveralBrowseCategories()
            .subscribe { [weak self] severalBrowseCategories in
                self?.categories.onNext(severalBrowseCategories)
            } onError: { error in
                self.categories.onError(error)
            }.disposed(by: self.bag)
    }
}
