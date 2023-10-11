//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by 홍진표 on 9/29/23.
//

import UIKit
import Then
import SnapKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Static constant
    static let identifier: String = "TitleHeaderCollectionReusableView"
    
    // MARK: - UI Component
    private let headerLabel: UILabel = UILabel().then {
        $0.textColor = .label
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 20 , weight: .semibold)
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //  frameBasedLayout()
        applyConstraints()
    }
    
    public func configureTitleHeader(args title: String) -> Void {
         
        headerLabel.text = title
    }
    
    private func frameBasedLayout() -> Void {
        
        headerLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: width - 30,
            height: height)
    }
    
    private func applyConstraints() -> Void {
        
        headerLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(10)
            make.top.equalTo(self)
            make.height.equalTo(self.height)
        }
    }
}
