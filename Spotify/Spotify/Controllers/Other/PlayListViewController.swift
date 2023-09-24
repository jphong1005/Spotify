//
//  PlayListViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit

class PlaylistViewController: UIViewController {

    // MARK: - Stored-Prop
    private let playlistItem: PlayList.SimplifiedPlaylist
    
    // MARK: - Inits
    init(item: PlayList.SimplifiedPlaylist) {
        self.playlistItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        
        self.title = "Album"
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.configurePlaylistViewController(with: playlistItem)
        
        APICaller.shared.getPlaylist(for: playlistItem)
    }
    
    func configurePlaylistViewController(with item: PlayList.SimplifiedPlaylist) -> Void {
        
        self.title = item.name
    }
}
