//
//  AlbumViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/24.
//

import UIKit

class AlbumViewController: UIViewController {

    // MARK: - Stored-Prop
    private let albumItem: NewReleasesResponse.Album.SimplifiedAlbum
    
    // MARK: - Inits
    init(item: NewReleasesResponse.Album.SimplifiedAlbum) {
        self.albumItem = item
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
        
        self.configureAlbumViewController(with: albumItem)
        
        APICaller.shared.getAlbum(for: albumItem)
    }
    
    private func configureAlbumViewController(with item: NewReleasesResponse.Album.SimplifiedAlbum) -> Void {
        
        self.title = item.name
    }
}
