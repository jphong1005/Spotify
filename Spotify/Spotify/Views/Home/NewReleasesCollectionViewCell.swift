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
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let numberOfTracksLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.numberOfLines = 0
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
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
        
        albumCoverImageView.image = nil
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
    }
    
    public func configureNewReleaseCollectionViewCellUI(value: CommonGroundModel.SimplifiedAlbum) -> Void {
        
        albumCoverImageView.sd_setImage(with: URL(string: value.images.first?.url ?? ""))
        albumNameLabel.text = value.name
        artistNameLabel.text = value.artists.first?.name
        numberOfTracksLabel.text = "Tracks: \(value.total_tracks)"
    }
    
    private func frameBasedLayout() -> Void {
        
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        let imageSize: CGFloat = contentView.height - 10
        let albumNameLabelSize = albumNameLabel.sizeThatFits(CGSize(
            width: (contentView.width - imageSize) - 10,
            height: (contentView.height - imageSize) - 10))
        
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize,
            height: imageSize)
        
        let albumLabelHeight: CGFloat = min(50, albumNameLabelSize.height)
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 5,
            width: albumNameLabelSize.width,
            height: albumLabelHeight)
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: albumNameLabel.bottom,
            width: (contentView.width - albumCoverImageView.right) - 10,
            height: 30)
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + 10, 
            y: albumCoverImageView.bottom - 40,
            width: numberOfTracksLabel.width,
            height: 40)
    }
    
    private func applyConstraints() -> Void {
        
        albumCoverImageView.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(5)
            make.width.height.equalTo(contentView.snp.height).offset(-10)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.height.lessThanOrEqualTo(50)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumNameLabel.snp.bottom)
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.height.equalTo(30)
        }
        
        numberOfTracksLabel.snp.makeConstraints { make in
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(albumCoverImageView.snp.bottom).offset(-40)
            make.height.equalTo(40)
        }
    }
}
