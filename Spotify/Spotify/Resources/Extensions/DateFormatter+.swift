//
//  DateFormatter+.swift
//  Spotify
//
//  Created by 홍진표 on 10/2/23.
//

import Foundation

// MARK: - Extension DateFormatter
extension DateFormatter {
    
    static let dateFormatter: DateFormatter = {
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
}
