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
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    private let trackNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let artistNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.numberOfLines = 0
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
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
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    public func configureRecommendationCollectionViewCell<T>(args params : T) -> Void {
        
        switch params {
        case let album as Album.Track.SimplifiedTrack:
            trackNameLabel.text = album.name
            artistNameLabel.text = album.artists.first?.name
            break;
        case let playlist as Playlist.Track.PlaylistTrack:
            albumCoverImageView.sd_setImage(with: URL(string: playlist.track?.album.images.first?.url ?? ""))
            trackNameLabel.text = playlist.track?.name
            artistNameLabel.text = playlist.track?.artists.first?.name
            break;
        case let recommendation as TrackObject:
            albumCoverImageView.sd_setImage(with: URL(string: recommendation.album.images.first?.url ?? ""))
            trackNameLabel.text = recommendation.name
            artistNameLabel.text = recommendation.artists.first?.name
            break;
        default:
            break;
        }
    }
    
    private func frameBasedLayout() -> Void {
        
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: contentView.height - 10,
            height: contentView.height - 10)
        
        trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 0,
            width: (contentView.width - albumCoverImageView.right) - 15,
            height: (contentView.height) / 2)
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: (contentView.height) / 2,
            width: (contentView.width - albumCoverImageView.right) - 15,
            height: (contentView.height) / 2)
    }
    
    private func applyConstraints() -> Void {
        
        albumCoverImageView.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(3)
            make.width.height.equalTo(contentView.snp.height).inset(3)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.left.equalTo(albumCoverImageView.snp.right).offset(10)
            make.top.equalTo(contentView.snp.top).offset(3)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.height.equalTo(contentView.snp.height).dividedBy(2)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.left.equalTo(trackNameLabel.snp.left)
            make.top.equalTo(contentView.snp.centerY).offset(-3)
            make.width.equalTo(trackNameLabel.snp.width)
            make.height.equalTo(trackNameLabel.snp.height)
        }
    }
}
