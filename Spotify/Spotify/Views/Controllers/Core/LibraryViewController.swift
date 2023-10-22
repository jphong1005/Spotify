//
//  LibraryViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import Then

class LibraryViewController: UIViewController {
    
    // MARK: - UI Components
    private let libraryPlaylistsVC: LibraryPlaylistsViewController = LibraryPlaylistsViewController()
    private let libraryAlbumsVC: LibraryAlbumsViewController = LibraryAlbumsViewController()
    
    private let scrollView: UIScrollView = UIScrollView().then {
        $0.isPagingEnabled = true
    }
    private let libraryToggleView: LibraryToggleView = LibraryToggleView()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        defaultConfigureLibraryViewController()
        configureLibraryViewController()
        
        addChildrenViewController()
        
        self.scrollView.delegate = self
        self.libraryToggleView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        frameBasedLayout()
    }
    
    private func defaultConfigureLibraryViewController() -> Void {
        
        view.backgroundColor = .systemBackground
        
        title = "Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.scrollView.contentSize = CGSize(width: view.width * 2, height: self.scrollView.height)
    }
    
    private func configureLibraryViewController() -> Void {
        
        view.addSubview(self.scrollView)
        view.addSubview(self.libraryToggleView)
    }
    
    private func frameBasedLayout() -> Void {
        
        self.scrollView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top + 50,
                                  width: view.width,
                                  height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 50)
        
        self.libraryToggleView.frame = CGRect(x: 0,
                                              y: view.safeAreaInsets.top,
                                              width: 200,
                                              height: 50)
    }
    
    private func addChildrenViewController() -> Void {
        
        /// LIbraryPlaylistsViewController
        addChild(libraryPlaylistsVC)
        
        self.scrollView.addSubview(libraryPlaylistsVC.view)
        
        libraryPlaylistsVC.view.frame = CGRect(x: 0,
                                               y: 0,
                                               width: self.scrollView.width,
                                               height: self.scrollView.height)
        libraryPlaylistsVC.didMove(toParent: self)
        
        /// LIbraryAlbumsViewController
        addChild(libraryAlbumsVC)
        
        self.scrollView.addSubview(libraryAlbumsVC.view)
        
        libraryAlbumsVC.view.frame = CGRect(x: view.width,
                                            y: 0,
                                            width: self.scrollView.width,
                                            height: self.scrollView.height)
        libraryAlbumsVC.didMove(toParent: self)
    }
}

// MARK: - Extension ViewController
extension LibraryViewController: UIScrollViewDelegate, LibraryToggleViewDelegate {
    
    // MARK: - UIScrollViewDelegate Method
    /// Optional Method.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.scrollView.contentOffset.x >= (view.width - 100)) {
            libraryToggleView.updateForState(args: .album)
        } else {
            libraryToggleView.updateForState(args: .playlist)
        }
    }
    
    // MARK: - LibraryToggleViewDelegate Methods Implementation
    func libraryToggleViewDidTapPlaylists(toggleView playlists: LibraryToggleView) {
        
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbums(toggleView albums: LibraryToggleView) {
        
        self.scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
}
