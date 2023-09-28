//
//  SettingsModels.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/10.
//

import Foundation

struct Section {
    
    // MARK: - Stored-Props
    let title: String
    let options: [Option]
    
    struct Option {
        
        // MARK: - Stored-Props
        let title: String
        let handler: (() -> Void)
    }
}
