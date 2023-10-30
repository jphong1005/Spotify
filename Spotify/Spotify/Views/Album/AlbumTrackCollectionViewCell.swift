//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 9/29/23.
//

import UIKit
import Then
import SnapKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static constant
    static let identifier: String = "AlbumTrackCollectionViewCell"
    
    // MARK: - UI Components
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
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(trackNameLabel)
        self.addSubview(artistNameLabel)
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
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    public func configureAlbumTrackCollectionViewCell(args album: CommonGroundModel.Track.SimplifiedTrack?) -> Void {
        
        trackNameLabel.text = album?.name
        artistNameLabel.text = album?.artists.first?.name
    }
    
    private func frameBasedLayout() -> Void {
        
        trackNameLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width - 20,
            height: contentView.height / 2)
        
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width - 20,
            height: contentView.height / 2)
    }
    
    private func applyConstraints() -> Void {
        
        trackNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(10)
            make.top.equalTo(contentView.snp.top)
            make.height.equalTo(contentView.snp.height).dividedBy(2)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView)
            make.height.equalTo(contentView).multipliedBy(0.5)
        }
    }
}
