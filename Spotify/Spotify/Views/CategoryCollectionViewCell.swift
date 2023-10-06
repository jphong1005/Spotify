//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 10/3/23.
//

import UIKit
import Then

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static constant
    static let identifier: String = "GenreCollectionViewCell"
    
    // MARK: - UI Components
    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    private let label: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(
            ofSize: 20,
            weight: .semibold)
    }
    
    // MARK: - Stored-Prop
    private let colours: [UIColor] = [
        UIColor.systemBlue,
        UIColor.systemYellow,
        UIColor.systemRed,
        UIColor.systemOrange,
        UIColor.systemGreen,
        UIColor.systemPurple,
        UIColor.systemPink,
        UIColor.systemTeal,
        UIColor.systemBrown,
        UIColor.systemGray,
        UIColor.black
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
        
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
        label.text = nil
    }
    
    public func configureGenreCollectionViewCell(args param: CommonGround.Category) -> Void {
        
        contentView.backgroundColor = colours.randomElement()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        imageView.sd_setImage(with: URL(string: param.icons.first?.url ?? ""))
        label.text = param.name
    }
    
    private func frameBasedLayout() -> Void {
        
        imageView.frame = CGRect(
            x: contentView.width / 2,
            y: 10,
            width: contentView.width / 2,
            height: contentView.height / 2)
        
        label.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width - 20,
            height: contentView.height / 2)
    }
}
