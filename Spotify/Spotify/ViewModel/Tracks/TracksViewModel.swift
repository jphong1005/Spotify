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
    var recommendations: BehaviorSubject<Recommendations?>
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.recommendations = BehaviorSubject(value: nil)
        
        addObserver()
    }
    
    // MARK: - Method
    private func addObserver() -> Void {
        
        Task {
            do {
                try await APICaller.shared.getRecommendations().value
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
