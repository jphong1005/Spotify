//
//  SpotifyViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/10.
//

import Foundation
import RxSwift
import RxCocoa

final class SpotifyViewModel {
    
    // MARK: - Stored-Props
    var userProfile: BehaviorSubject<UserProfile?> = BehaviorSubject(value: nil)
    var newReleases: BehaviorSubject<NewReleasesResponse?> = BehaviorSubject(value: nil)
    var recommendations: BehaviorSubject<RecommendationsResponse?> = BehaviorSubject(value: nil)
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        APICaller.shared.getCurrentUserProfile()
            .subscribe { [weak self] profile in
                self?.userProfile.onNext(profile)
            } onError: { error in
                self.userProfile.onError(error)
            }.disposed(by: self.bag)
        
        APICaller.shared.getNewReleases()
            .subscribe { [weak self] releases in
                self?.newReleases.onNext(releases)
            } onError: { error in
                self.newReleases.onError(error)
            }.disposed(by: self.bag)
        
        Task {
            do {
                try await APICaller.shared.performGetRecommendations().value
                    .subscribe(onNext: { [weak self] recommendations in
                        self?.recommendations.onNext(recommendations)
                    }, onError: { error in
                        self.recommendations.onError(error)
                    }).disposed(by: self.bag)
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
