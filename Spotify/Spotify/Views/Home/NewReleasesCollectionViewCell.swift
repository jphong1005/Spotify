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
    }
    
    private let albumNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let numberOfTracksLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .light)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let artistNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .secondarySystemBackground
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(albumCoverImageView)
        self.contentView.addSubview(albumNameLabel)
        self.contentView.addSubview(numberOfTracksLabel)
        self.contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.applyConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumCoverImageView.image = nil
        albumNameLabel.text = nil
        numberOfTracksLabel.text = nil
        artistNameLabel.text = nil
    }
    
    public func configureNewReleaseCollectionViewCellUI(value: NewReleasesResponse.Album.SimplifiedAlbum) -> Void {
        
        albumCoverImageView.sd_setImage(with: URL(string: value.images.first?.url ?? ""))
        albumNameLabel.text = value.name
        numberOfTracksLabel.text = "Tracks: \(value.total_tracks)"
        artistNameLabel.text = value.artists.first?.name ?? ""
    }
    
    private func applyConstraints() -> Void {
        
        //  albumCoverImageView
        albumCoverImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(5)
            make.width.height.equalTo(contentView.snp.height).offset(-10)
        }
        
        //  albumNameLabel
        albumNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
            make.height.equalTo(60).priority(.high)
        }
        
        //  numberOfTracksLabel
        numberOfTracksLabel.snp.makeConstraints { make in
            make.top.equalTo(albumCoverImageView.snp.bottom).offset(-44)
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.width.equalTo(numberOfTracksLabel.snp.width)
            make.height.equalTo(44)
        }
        
        //  artistNameLabel
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumNameLabel.snp.bottom)
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        /*
        override func layoutSubviews() {
            super.layoutSubviews()
            let imageSize: CGFloat = contentView.height-10
            let albumLabelSize = albumNameLabel.sizeThatFits(
                CGSize(
                    width: contentView.width-imageSize-10,
                    height: contentView.height-imageSize-10
                )
            )
            
            artistNameLabel.sizeToFit()
            numberOfTrackLabel.sizeToFit()
            //Image
            albumCoverImageView.frame = CGRect(
                x: 5,
                y: 5,
                width: imageSize,
                height: imageSize)
            
            // Album Name Label
            let albumLabelHeight = min(60, albumLabelSize.height)
            
            albumNameLabel.frame = CGRect(
                x: albumCoverImageView.right+10,
                y: 5,
                width:  albumLabelSize.width,
                height: albumLabelHeight)
            
            artistNameLabel.frame = CGRect(
                x: albumCoverImageView.right+10,
                y: albumNameLabel.bottom,
                width:  contentView.width - albumCoverImageView.right-10,
                height: 30)
            
            numberOfTrackLabel.frame = CGRect(
                x: albumCoverImageView.right+10,
                y: albumCoverImageView.bottom-44,
                width:  numberOfTrackLabel.width,
                height: 44)
        }
         */
    }
}
