//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 10/3/23.
//

import UIKit
import Then
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static constant
    static let identifier: String = "CategoryCollectionViewCell"
    
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
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
        label.text = nil
    }
    
    public func configureCategoryCollectionViewCell(args category: CommonGroundModel.Category) -> Void {
        
        contentView.backgroundColor = colours.randomElement()
        
        
        
        imageView.sd_setImage(with: URL(string: category.icons.first?.url ?? ""))
        label.text = category.name
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
    
    private func applyConstraints() -> Void {
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(contentView.bounds.width / 2)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.width.equalTo(contentView.snp.width).dividedBy(2)
            make.height.equalTo(contentView.snp.height).dividedBy(2)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalTo(contentView.snp.width).offset(-20)
            make.height.equalTo(contentView.snp.height).dividedBy(2)
        }
    }
}
