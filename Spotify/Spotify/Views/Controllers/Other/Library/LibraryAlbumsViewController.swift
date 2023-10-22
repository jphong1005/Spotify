//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by 홍진표 on 10/22/23.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigureLibraryAlbumsViewController()
    }
    
    private func defaultConfigureLibraryAlbumsViewController() -> Void {
        
        view.backgroundColor = .systemBackground
    }
}
