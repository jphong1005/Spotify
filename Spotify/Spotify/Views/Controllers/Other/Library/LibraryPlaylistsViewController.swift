//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by 홍진표 on 10/22/23.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigureLibraryPlaylistsViewController()
    }
    
    private func defaultConfigureLibraryPlaylistsViewController() -> Void {
        
        view.backgroundColor = .systemBackground
    }
}
