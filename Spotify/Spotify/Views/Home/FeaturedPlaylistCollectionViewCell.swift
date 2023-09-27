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
        $0.font = .systemFont(ofSize: 20, weight: .regular)
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
        
        self.contentView.backgroundColor = .secondarySystemBackground
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(playlistCoverImageView)
        self.contentView.addSubview(playlistNameLabel)
        self.contentView.addSubview(creatorNameLabel)
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
        
        playlistCoverImageView.image = nil
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
    }
    
    public func configureFeaturedPlaylistCollectionViewCellUI(value: FeaturedPlaylists.PlayList.SimplifiedPlaylist) -> Void {
        
        playlistCoverImageView.sd_setImage(with: URL(string: value.images.first?.url ?? ""))
        playlistNameLabel.text = value.name
        creatorNameLabel.text = value.owner.display_name
    }
    
    private func frameBasedLayout() -> Void {
        
        let imageSize: CGFloat = self.contentView.height - 70
        
        self.playlistCoverImageView.frame = CGRect(x: (self.contentView.width - imageSize) / 2,
                                                   y: 5,
                                                   width: imageSize,
                                                   height: imageSize)
        
        self.playlistNameLabel.frame = CGRect(x: 3,
                                              y: self.contentView.height - 50,
                                              width: self.contentView.width - 5,
                                              height: 30)
        
        self.creatorNameLabel.frame = CGRect(x: 3,
                                             y: self.contentView.height - 30,
                                             width: self.contentView.width - 8,
                                             height: 30)
    }
    
    private func applyConstraints() -> Void {
        
        let imageSize: CGFloat = self.contentView.height - 70
        
        self.playlistCoverImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.top.equalTo(self.contentView.snp.top).offset(5)
            make.width.height.equalTo(imageSize)
        }
        
        self.playlistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading).offset(3)
            make.top.equalTo(self.contentView.height - 50)
            make.width.equalTo(self.contentView.width - 5)
            make.height.equalTo(30)
        }
        
        self.creatorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.playlistNameLabel.snp.leading)
            make.top.equalTo(self.contentView.height - 30)
            make.width.equalTo(self.contentView.width - 8)
            make.height.equalTo(self.playlistNameLabel.snp.height)
        }
    }
}
