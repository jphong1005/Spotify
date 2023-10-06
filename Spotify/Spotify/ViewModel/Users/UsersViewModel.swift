//
//  UsersViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/16.
//

import Foundation
import RxSwift
import RxCocoa

final class UsersViewModel {
    
    // MARK: - Stored-Props
    var userProfile: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getCurrentUserProfile()
            .subscribe { [weak self] profile in
                self?.userProfile.onNext(profile)
            } onError: { error in
                self.userProfile.onError(error)
            }.disposed(by: self.bag)
    }
}
