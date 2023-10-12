//
//  SearchResultSubTitleTableViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 10/12/23.
//

import UIKit
import Then
import SnapKit
import SDWebImage

class SearchResultSubTitleTableViewCell: UITableViewCell {

    // MARK: - Static Constant
    static let identifier: String = "SearchResultSubTitleTableViewCell"
    
    // MARK: - UI Components
    private let iconImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let label: UILabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    private let subTitleLabel: UILabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .secondaryLabel
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        defaultSearchResultSubTitleTableViewCell()
        
        frameBasedLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
        subTitleLabel.text = nil
    }
    
    private func defaultSearchResultSubTitleTableViewCell() -> Void {
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(subTitleLabel)
        
        contentView.clipsToBounds = true
        
        accessoryType = .disclosureIndicator
    }
    
    private func frameBasedLayout() -> Void {
        
        let imageSize: CGFloat = contentView.height - 10
        
        iconImageView.frame = CGRect(x: 10,
                                     y: 5,
                                     width: imageSize,
                                     height: imageSize)
        
        let labelHeight: CGFloat = contentView.height / 2
        
        label.frame = CGRect(x: iconImageView.right + 10,
                             y: 0,
                             width: (contentView.width - iconImageView.right) - 15,
                             height: labelHeight)
        
        subTitleLabel.frame = CGRect(x: iconImageView.right + 10,
                                     y: label.bottom,
                                     width: (contentView.width - iconImageView.right) - 15,
                                     height: labelHeight)
    }
    
    public func configureSearchResultSubTitleViewCell<T>(args caseType: T) -> Void {
        
        switch caseType {
        case let track as TrackObject:
            iconImageView.sd_setImage(with: URL(string: track.album.images.first?.url ?? ""))
            label.text = track.name
            subTitleLabel.text = track.artists.first?.name
            break;
        case let album as CommonGroundModel.SimplifiedAlbum:
            iconImageView.sd_setImage(with: URL(string: album.images.first?.url ?? ""))
            label.text = album.name
            subTitleLabel.text = album.artists.first?.name
            break;
        case let playlist as CommonGroundModel.SimplifiedPlaylist:
            iconImageView.sd_setImage(with: URL(string: playlist.images.first?.url ?? ""))
            label.text = playlist.name
            subTitleLabel.text = playlist.owner.display_name
            break;
        case let show as CommonGroundModel.SimplifiedShow:
            iconImageView.sd_setImage(with: URL(string: show.images.first?.url ?? ""))
            label.text = show.name
            subTitleLabel.text = show.publisher
            break;
        default:
            break;
        }
    }
}
