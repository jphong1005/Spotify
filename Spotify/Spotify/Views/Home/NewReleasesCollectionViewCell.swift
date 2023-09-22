//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/16.
//

import UIKit
import Then
import SDWebImage
import SnapKit

class NewReleasesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static constant
    static let identifier: String = "NewReleaseCollectionViewCell"
    
    // MARK: - UI Components
    private let albumCoverImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private let albumNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
    }
    
    private let artistNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let numberOfTracksLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.numberOfLines = 0
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .secondarySystemBackground
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(albumCoverImageView)
        self.contentView.addSubview(albumNameLabel)
        self.contentView.addSubview(artistNameLabel)
        self.contentView.addSubview(numberOfTracksLabel)
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
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
    }
    
    public func configureNewReleaseCollectionViewCellUI(value: NewReleasesResponse.Album.SimplifiedAlbum) -> Void {
        
        self.albumCoverImageView.sd_setImage(with: URL(string: value.images.first?.url ?? ""))
        self.albumNameLabel.text = value.name
        self.artistNameLabel.text = value.artists.first?.name ?? ""
        self.numberOfTracksLabel.text = "Tracks: \(value.total_tracks)"
    }
    
    private func frameBasedLayout() -> Void {
        
        self.artistNameLabel.sizeToFit()
        self.numberOfTracksLabel.sizeToFit()
        
        let imageSize: CGFloat = self.contentView.height - 10
        let albumNameLabelSize = self.albumNameLabel.sizeThatFits(CGSize(width: (self.contentView.width - imageSize) - 10,
                                                                         height: (self.contentView.height - imageSize) - 10))
        
        self.albumCoverImageView.frame = CGRect(x: 5,
                                                y: 5,
                                                width: imageSize,
                                                height: imageSize)
        
        let albumLabelHeight: CGFloat = min(50, albumNameLabelSize.height)
        
        self.albumNameLabel.frame = CGRect(x: self.albumCoverImageView.right + 10,
                                           y: 5,
                                           width: albumNameLabelSize.width,
                                           height: albumLabelHeight)
        
        self.artistNameLabel.frame = CGRect(x: self.albumCoverImageView.right + 10,
                                            y: self.albumNameLabel.bottom,
                                            width: (self.contentView.width - self.albumCoverImageView.right) - 10,
                                            height: 30)
        
        self.numberOfTracksLabel.frame = CGRect(x: self.albumCoverImageView.right + 10,
                                                y: self.albumCoverImageView.bottom - 40,
                                                width: self.numberOfTracksLabel.width,
                                                height: 40)
    }
    
    private func applyConstraints() -> Void {
        
        self.albumCoverImageView.snp.makeConstraints { make in
            make.top.left.equalTo(self.contentView).offset(5)
            make.width.height.equalTo(self.contentView.snp.height).offset(-10)
        }
        
        self.albumNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.leading.equalTo(self.albumCoverImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-10)
            make.height.lessThanOrEqualTo(50)
        }
        
        self.artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.albumNameLabel.snp.bottom)
            make.leading.equalTo(self.albumCoverImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-10)
            make.height.equalTo(30)
        }
        
        self.numberOfTracksLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.albumCoverImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-10)
            make.top.equalTo(self.albumCoverImageView.snp.bottom).offset(-40)
            make.height.equalTo(40)
        }
    }
}
