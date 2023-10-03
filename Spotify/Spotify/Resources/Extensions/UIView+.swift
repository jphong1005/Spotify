//
//  UIView+.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/01.
//

import Foundation
import UIKit

// MARK: - Extension UIView
extension UIView {
    
    // MARK: - Computed-Props
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}
