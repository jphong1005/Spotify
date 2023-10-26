//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by 홍진표 on 10/22/23.
//

import UIKit
import Then

protocol LibraryToggleViewDelegate: AnyObject {
    
    // MARK: - Function Prototype
    func libraryToggleViewDidTapPlaylists(toggleView playlists: LibraryToggleView) -> Void
    func libraryToggleViewDidTapAlbums(toggleView albums: LibraryToggleView) -> Void
}

class LibraryToggleView: UIView {

    // MARK: - Stored-Props
    private let defaultXpoint: Int = 10
    weak var delegate: LibraryToggleViewDelegate? = nil
    var state: State = .playlist
    
    // MARK: - UI Components
    private let playlistButton: UIButton = UIButton().then {
        $0.setTitle("Playlists", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.addTarget(self, action: #selector(didTapPlaylists(_:)), for: .touchUpInside)
    }
    
    private let albumButton: UIButton = UIButton().then {
        $0.setTitle("Albums", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.addTarget(self, action: #selector(didTapAlbums(_:)), for: .touchUpInside)
    }
    
    private let indicatorView: UIView = UIView().then {
        $0.backgroundColor = .systemGreen
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.playlistButton)
        self.addSubview(self.albumButton)
        self.addSubview(self.indicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frameBasedLayout()
    }
    
    private func frameBasedLayout() -> Void {
        
        self.playlistButton.frame = CGRect(x: defaultXpoint, y: 0, width: 100, height: 30)
        self.albumButton.frame = CGRect(x: (defaultXpoint * 2) + 100, y: 0, width: 100, height: 30)
        
        layoutIndicator()
    }
    
    private func layoutIndicator() -> Void {
        
        switch state {
        case .playlist:
            self.indicatorView.frame = CGRect(x: defaultXpoint, y: Int(self.playlistButton.bottom), width: 100, height: 3)
            break;
        case .album:
            self.indicatorView.frame = CGRect(x: (defaultXpoint * 2) + 100, y: Int(self.playlistButton.bottom), width: 100, height: 3)
            break;
        }
    }
    
    public func updateForState(args params: State) -> Void {
        
        self.state = params
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    
    // MARK: - Event Handler Methods
    @objc private func didTapPlaylists(_ sender: UIButton) -> Void {
        
        state = .playlist
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        delegate?.libraryToggleViewDidTapPlaylists(toggleView: self)
    }
    
    @objc private func didTapAlbums(_ sender: UIButton) -> Void {
        
        state = .album
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        
        delegate?.libraryToggleViewDidTapAlbums(toggleView: self)
    }
}
