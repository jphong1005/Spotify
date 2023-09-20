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
        //  $0.sizeToFit()
    }
    
    private let creatorNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        //  $0.sizeToFit()
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
        
        //  self.applyConstraints()
        
        creatorNameLabel.frame = CGRect(
                    x: 3,
                    y: contentView.height-30,
                    width: contentView.width-6,
                    height: 30)
                playlistNameLabel.frame = CGRect(
                    x: 3,
                    y: contentView.height-60,
                    width: contentView.width-6,
                    height: 30)
                // imagesize
                let imageSize = contentView.height-70
                playlistCoverImageView.frame = CGRect(x: (contentView.width-imageSize)/2, y: 3, width: imageSize, height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playlistCoverImageView.image = nil
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
    }
    
    public func configureFeaturedPlaylistCollectionViewCellUI(value: PlayList.SimplifiedPlaylist) -> Void {
        
        playlistCoverImageView.sd_setImage(with: URL(string: value.images.first?.url ?? ""))
        playlistNameLabel.text = value.name
        creatorNameLabel.text = value.owner.display_name
    }
    
    private func applyConstraints() -> Void {
        
        //  playlistCoverImageView
        playlistCoverImageView.snp.makeConstraints { make in
            
        }
        
        //  playlistNameLabel
        playlistNameLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        //  creatorNameLabel
        creatorNameLabel.snp.makeConstraints { make in
            make.height.equalTo(self.playlistNameLabel.snp.height)
        }
    }
}
