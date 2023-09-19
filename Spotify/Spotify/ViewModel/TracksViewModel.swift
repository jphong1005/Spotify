//
//  TracksViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/16.
//

import Foundation
import RxSwift
import RxCocoa

final class TracksViewModel {
    
    // MARK: - Stored-Props
    var recommendations: BehaviorSubject<RecommendationsResponse?> = BehaviorSubject(value: nil)
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
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
