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
        
        albumCoverImageView.frame = CGRect(x: 5, y: 2, width: contentView.height, height: contentView.height-4)
                trackNameLabel.frame = CGRect(
                    x: albumCoverImageView.right+10,
                    y: 0,
                    width: contentView.width-albumCoverImageView.right-15,
                    height: contentView.height/2
                )
                artistNameLabel.frame = CGRect(
                    x: albumCoverImageView.right+10,
                    y: contentView.height/2 ,
                    width: contentView.width-albumCoverImageView.right-15,
                    height: contentView.height/2
                )
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
                                                y: 2,
                                                width: self.contentView.height,
                                                height: self.contentView.height - 4)
    }
}
