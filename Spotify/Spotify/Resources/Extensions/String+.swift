//
//  String+.swift
//  Spotify
//
//  Created by 홍진표 on 10/2/23.
//

import Foundation

// MARK: - Extension String
extension String {
    
    static func formattedDate(args str: String) -> String {
        
        guard let date: Date = DateFormatter.dateFormatter.date(from: str) else { return str }
        
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
