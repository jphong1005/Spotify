//
//  DefaultSearchResultTableViewCell.swift
//  Spotify
//
//  Created by 홍진표 on 10/12/23.
//

import UIKit
import Then
import SnapKit
import SDWebImage

class DefaultSearchResultTableViewCell: UITableViewCell {

    // MARK: - Static Constant
    static let identifier: String = "DefaultSearchResultTableViewCell"
    
    // MARK: - UI Components
    private let iconImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let label: UILabel = UILabel().then {
        $0.numberOfLines = 1
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
        
        defaultConfigureDefaultSearchResultTableViewCell()
        
        frameBasedLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
    }
    
    private func defaultConfigureDefaultSearchResultTableViewCell() -> Void {
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        
        contentView.clipsToBounds = true
        
        accessoryType = .disclosureIndicator
    }
    
    private func frameBasedLayout() -> Void {
        
        let imageSize: CGFloat = contentView.height - 10
        
        iconImageView.frame = CGRect(x: 10,
                                     y: 5,
                                     width: imageSize,
                                     height: imageSize)
        iconImageView.layer.cornerRadius = imageSize / 2
        iconImageView.layer.masksToBounds = true
        
        label.frame = CGRect(x: iconImageView.right + 10,
                             y: 0,
                             width: (contentView.width - iconImageView.right) - 15,
                             height: contentView.height)
    }
    
    public func configureDefaultSearchResultTableViewCell<T>(args parameter: T) -> Void {
        
        switch parameter {
        case let artist as CommonGroundModel.ArtistObject:
            if ((artist.images?.first?.url == nil) || (artist.images?.first?.url == "")) {
                iconImageView.image = UIImage(systemName: "person")
                label.text = artist.name
            } else {
                iconImageView.sd_setImage(with: URL(string: artist.images?.first?.url ?? ""))
                label.text = artist.name
            }
            break;
        default:
            break;
        }
    }
}
