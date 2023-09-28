//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/27.
//

import UIKit
import Then
import SDWebImage
import SnapKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    
    // MARK: - Function Prototype
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(header: PlaylistHeaderCollectionReusableView) -> Void
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Static constant & Stored-Prop
    static let identifier: String = "PlaylistHeaderCollectionReusableView"
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?    //  Dependency Injection
    
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
    
    private let playButton: UIButton = UIButton().then {
        $0.backgroundColor = .systemGreen
        $0.setImage(UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                           weight: .regular)),
                    for: .normal)
        $0.tintColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapPlayAll(_:)), for: .touchUpInside)
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(playlistImageView)
        self.addSubview(playlistNameLabel)
        self.addSubview(playlistDescriptionLabel)
        self.addSubview(playlistOwnerLabel)
        self.addSubview(playButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frameBasedLayout()
        //  applyConstraints()
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
                                         width: self.width - 20, 
                                         height: 45)
        
        playlistDescriptionLabel.frame = CGRect(x: 10,
                                         y: playlistNameLabel.bottom,
                                         width: self.width - 20, 
                                                height: 45)
        
        playlistOwnerLabel.frame = CGRect(x: 10,
                                         y: playlistDescriptionLabel.bottom,
                                         width: self.width - 20, 
                                          height: 45)
        
        playButton.frame = CGRect(x: self.width - 80,
                                  y: self.height - 80,
                                  width: 60,
                                  height: 60)
    }
    
    private func applyConstraints() -> Void {
        
        let imageSize: CGFloat = self.height / 2.0
        
        playlistImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.width.height.equalTo(imageSize)
        }
        
        playlistNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(10)
            make.top.equalTo(self.playlistImageView.snp.bottom)
            make.height.equalTo(45)
        }
        
        playlistDescriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(10)
            make.top.equalTo(self.playlistNameLabel.snp.bottom)
            make.height.equalTo(self.playlistNameLabel.snp.height)
        }
        
        playlistOwnerLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(10)
            make.top.equalTo(self.playlistDescriptionLabel.snp.bottom)
            make.height.equalTo(self.playlistDescriptionLabel.snp.height)
        }
    }
    
    @objc private func didTapPlayAll(_ sender: UIButton) -> Void {
        
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(header: self)
    }
}
