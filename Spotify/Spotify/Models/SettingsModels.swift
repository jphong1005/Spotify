//
//  SettingsModels.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/10.
//

import Foundation

struct Section {
    
    // MARK: - Stored-Props
    let strTitle: String
    let arrOptions: [Option]
    
    struct Option {
        
        // MARK: - Stored-Props
        let strTitle: String
        let handler: (() -> Void)
    }
}
