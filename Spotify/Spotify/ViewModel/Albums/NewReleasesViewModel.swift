//
//  NewReleasesViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/16.
//

import Foundation
import RxSwift
import RxCocoa

final class NewReleasesViewModel {
    
    // MARK: - Stored-Props
    var newReleases: BehaviorSubject<NewReleases?>
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.newReleases = BehaviorSubject(value: nil)
        
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getNewReleases()
            .subscribe { [weak self] releases in
                self?.newReleases.onNext(releases)
            } onError: { error in
                self.newReleases.onError(error)
            }.disposed(by: self.bag)
    }
}
