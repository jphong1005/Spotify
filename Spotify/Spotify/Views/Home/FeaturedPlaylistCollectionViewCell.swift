//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/16.
//

import UIKit
import Then
import SDWebImage
import SnapKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static constant
    static let identifier: String = "FeaturedPlaylistCollectionViewCell"
    
    // MARK: - UI Components
    private let playlistCoverImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private let playlistNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let creatorNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
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
        
        playlistCoverImageView.image = nil
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
    }
    
    public func configureFeaturedPlaylistCollectionViewCellUI(args param: Playlists.Playlist.SimplifiedPlaylist) -> Void {
        
        playlistCoverImageView.sd_setImage(with: URL(string: param.images.first?.url ?? ""))
        playlistNameLabel.text = param.name
        creatorNameLabel.text = param.owner.display_name
    }
    
    private func frameBasedLayout() -> Void {
        
        let imageSize: CGFloat = contentView.height - 70
        
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width - imageSize) / 2,
            y: 5,
            width: imageSize,
            height: imageSize)
        
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 50,
            width: contentView.width - 5,
            height: 30)
        
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 30,
            width: contentView.width - 8,
            height: 30)
    }
    
    private func applyConstraints() -> Void {
        
        let imageSize: CGFloat = contentView.height - 70
        
        playlistCoverImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(5)
            make.width.height.equalTo(imageSize)
        }
        
        playlistNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(3)
            make.top.equalTo(contentView.snp.bottom).offset(-55)
            make.height.equalTo(30)
        }
        
        creatorNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(playlistNameLabel)
            make.top.equalTo(contentView.snp.bottom).offset(-30)
            make.height.equalTo(playlistNameLabel.snp.height)
        }
    }
}
