//
//  RecommendationCollectionViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/16.
//

import UIKit
import Then
import SDWebImage
import SnapKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static constant
    static let identifier: String = "RecommendationCollectionViewCell"
    
    // MARK: - UI Components
    private let albumCoverImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private let trackNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let artistNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.numberOfLines = 0
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .secondarySystemBackground
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(albumCoverImageView)
        self.contentView.addSubview(trackNameLabel)
        self.contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //  self.frameBasedLayout()
        self.applyConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumCoverImageView.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    public func configureRecommendationCollectionViewCell(value: Track) -> Void {
        
        albumCoverImageView.sd_setImage(with: URL(string: value.album.images.first?.url ?? ""))
        trackNameLabel.text = value.name
        artistNameLabel.text = value.artists.first?.name
    }
    
    private func frameBasedLayout() -> Void {
        
        self.albumCoverImageView.frame = CGRect(x: 5,
                                                y: 5,
                                                width: self.contentView.height - 10,
                                                height: self.contentView.height - 10)
        
        self.trackNameLabel.frame = CGRect(x: self.albumCoverImageView.right + 10,
                                           y: 0, 
                                           width: (self.contentView.width - self.albumCoverImageView.right) - 15,
                                           height: (self.contentView.height) / 2)
        
        self.artistNameLabel.frame = CGRect(x: self.albumCoverImageView.right + 10,
                                            y: (self.contentView.height) / 2,
                                            width: (self.contentView.width - self.albumCoverImageView.right) - 15,
                                            height: (self.contentView.height) / 2)
    }
    
    private func applyConstraints() -> Void {
        
        self.albumCoverImageView.snp.makeConstraints { make in
            make.top.left.equalTo(self.contentView).offset(5)
            make.width.height.equalTo(self.contentView.snp.height).offset(-10)
        }
        
        self.trackNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.albumCoverImageView.snp.trailing).offset(10)
            make.top.equalTo(self.contentView.snp.top)
            make.width.equalTo((self.contentView.width) - (self.albumCoverImageView.height) - 15)
            make.height.equalTo(self.contentView.snp.height).dividedBy(2)
        }
        
        self.artistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.trackNameLabel.snp.leading)
            make.top.equalTo(self.contentView.snp.height).dividedBy(2)
            make.width.equalTo((self.contentView.width) - (self.albumCoverImageView.right) - 15)
            make.height.equalTo(self.contentView.snp.height).dividedBy(2)
        }
    }
}
