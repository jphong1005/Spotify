//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/27.
//

import UIKit
import Then
import SDWebImage

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Static constant
    static let identifier: String = "PlaylistHeaderCollectionReusableView"
    
    // MARK: - UI Components
    private let playlistImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "photo")
    }
    
    private let playlistNameLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let playlistDescriptionLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
    }
    
    private let playlistOwnerLabel: UILabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .thin)
        $0.textColor = .secondaryLabel
    }
    
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        self.addSubview(playlistImageView)
        self.addSubview(playlistNameLabel)
        self.addSubview(playlistDescriptionLabel)
        self.addSubview(playlistOwnerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frameBasedLayout()
    }
    
    public func configure(with featuredPlaylist: FeaturedPlaylists.PlayList.SimplifiedPlaylist) -> Void {
        
        playlistImageView.sd_setImage(with: URL(string: featuredPlaylist.images.first?.url ?? ""))
        playlistNameLabel.text = featuredPlaylist.name
        playlistDescriptionLabel.text = featuredPlaylist.description
        playlistOwnerLabel.text = featuredPlaylist.owner.display_name
    }
    
    private func frameBasedLayout() -> Void {
        
        let imageSize: CGFloat = self.height / 2.0
        
        playlistImageView.frame = CGRect(x: (self.width - imageSize) / 2,
                                         y: 20,
                                         width: imageSize,
                                         height: imageSize)
        
        playlistNameLabel.frame = CGRect(x: 10,
                                         y: playlistImageView.bottom,
                                         width: self.width - 20, height: 45)
        
        playlistDescriptionLabel.frame = CGRect(x: 10,
                                         y: playlistNameLabel.bottom,
                                         width: self.width - 20, height: 45)
        
        playlistOwnerLabel.frame = CGRect(x: 10,
                                         y: playlistDescriptionLabel.bottom,
                                         width: self.width - 20, height: 45)
    }
}
