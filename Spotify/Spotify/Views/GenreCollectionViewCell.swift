//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 10/3/23.
//

import UIKit
import Then

class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static constant
    static let identifier: String = "GenreCollectionViewCell"
    
    // MARK: - UI Components
    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
    }
    
    private let label: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(
            ofSize: 20,
            weight: .semibold)
    }
    
    // MARK: - Stored-Prop
    private let colours: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .systemGray,
        .systemTeal
    ]
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frameBasedLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    public func configureGenreCollectionViewCell(args param: String) -> Void {
        
        contentView.backgroundColor = colours.randomElement()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        label.text = param
    }
    
    private func frameBasedLayout() -> Void {
        
        imageView.frame = CGRect(
            x: contentView.width / 2,
            y: 0,
            width: contentView.width / 2,
            height: contentView.height / 2)
        
        label.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width - 20,
            height: contentView.height / 2)
    }
}
