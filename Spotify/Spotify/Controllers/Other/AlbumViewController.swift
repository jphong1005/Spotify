//
//  AlbumViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/24.
//

import UIKit

class AlbumViewController: UIViewController {

    // MARK: - Stored-Prop
    private let albumItem: CommonGround.SimplifiedAlbum
    
    // MARK: - Inits
    init(item: CommonGround.SimplifiedAlbum) {
        albumItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        title = "Album"
        navigationItem.largeTitleDisplayMode = .never
        
        configureAlbumViewController(with: albumItem)
        
        APICaller.shared.getAlbum(for: albumItem)
    }
    
    private func configureAlbumViewController(with item: CommonGround.SimplifiedAlbum) -> Void {
        
        title = item.name
    }
}
