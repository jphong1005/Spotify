//
//  HapticsManager.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import Foundation
import UIKit

final class HapticsManager {
    
    // MARK: - Singleton Instance
    static let shared: HapticsManager = HapticsManager()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Methods
    public func vibrateForSelection() -> Void {
        
        DispatchQueue.main.async {
            let generator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
            
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) -> Void {
        
        DispatchQueue.main.async {
            let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
            
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
