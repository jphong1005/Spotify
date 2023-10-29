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
import SwiftSoup

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
        
        let buttonSize: CGFloat = 50
        
        $0.backgroundColor = .systemGreen
        $0.setImage(UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 20, 
                weight: .regular))?
            .withTintColor(
                .black,
                renderingMode: .alwaysOriginal),
                    for: .normal)
        $0.tintColor = .white
        $0.layer.cornerRadius = buttonSize / 2
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
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frameBasedLayout()
    }
    
    public func configurePlaylistHeader<T>(args params: T) -> Void {
        
        switch params {
        case let featuredPlaylist as CommonGroundModel.SimplifiedPlaylist:
            do {
                /// Parsing Data
                let doc: Document = try SwiftSoup.parse(featuredPlaylist.description)
                
                /// Get Plain Text
                let text: String = try doc.text()
                
                playlistImageView.sd_setImage(with: URL(string: featuredPlaylist.images.first?.url ?? ""), placeholderImage: UIImage(systemName: "photo"))
                playlistNameLabel.text = featuredPlaylist.name
                playlistDescriptionLabel.text = text
                playlistOwnerLabel.text = featuredPlaylist.owner.display_name
                break;
            } catch Exception.Error(type: let type, Message: let message) {
                print("type: \(type)")
                print("message: \(message)")
            } catch {
                print("error: \(error.localizedDescription)")
            }
        case let album as Album:
            playlistImageView.sd_setImage(with: URL(string: album.images.first?.url ?? ""), placeholderImage: UIImage(systemName: "photo"))
            playlistNameLabel.text = album.name
            playlistDescriptionLabel.text = "Release Date: \(String.formattedDate(args: album.release_date))"
            playlistOwnerLabel.text = album.artists.first?.name
        default:
            break;
        }
    }
    
    private func frameBasedLayout() -> Void {
        
        let imageSize: CGFloat = self.height / 2.0
        
        playlistImageView.frame = CGRect(
            x: (self.width - imageSize) / 2, 
            y: 20,
            width: imageSize,
            height: imageSize)
        
        playlistNameLabel.frame = CGRect(
            x: 10, 
            y: playlistImageView.bottom,
            width: self.width - 20,
            height: 45)
        
        playlistDescriptionLabel.frame = CGRect(
            x: 10, 
            y: playlistNameLabel.bottom,
            width: self.width - 20,
            height: 45)
        
        playlistOwnerLabel.frame = CGRect(
            x: 10, 
            y: playlistDescriptionLabel.bottom,
            width: self.width - 20,
            height: 45)
        
        playButton.frame = CGRect(
            x: self.width - 80, 
            y: self.height - 80,
            width: 50,
            height: 50)
    }
    
    // MARK: - Event Handler Method
    @objc private func didTapPlayAll(_ sender: UIButton) -> Void {
        
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(header: self)
    }
}
