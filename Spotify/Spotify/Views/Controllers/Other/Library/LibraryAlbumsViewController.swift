//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by 홍진표 on 10/22/23.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class LibraryAlbumsViewController: UIViewController {

    // MARK: - UI Components
    private let actionLabelView: ActionLabelView = ActionLabelView()
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(SearchResultSubTitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        $0.isHidden = true
    }
    
    // MARK: - Stored-Props
    private let albumViewModel: AlbumViewModel = AlbumViewModel()
    private var bag: DisposeBag = DisposeBag()
    
    public var albums: [CommonGroundModel.SimplifiedAlbum?] = []
    private var observer: NSObjectProtocol?
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigureLibraryAlbumsViewController()
        
        defaultConfigureLibraryPlaylistsViewController()
        configureLibraryPlaylistsViewController()
        
        actionLabelView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        frameBasedLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updatePlaylists()
    }
    
    private func defaultConfigureLibraryAlbumsViewController() -> Void {
        
        view.backgroundColor = .systemBackground
    }
    
    private func defaultConfigureLibraryPlaylistsViewController() -> Void {
        
        view.backgroundColor = .systemBackground
        
        actionLabelView.configureActionLabelView(first_args: "You have not saved any albums yet.", second_args: "Home")
    }
    
    private func configureLibraryPlaylistsViewController() -> Void {
        
        view.addSubview(actionLabelView)
        view.addSubview(self.tableView)
    }
    
    private func frameBasedLayout() -> Void {
        
        actionLabelView.frame = CGRect(x: (view.width - 150) / 2 , y: (view.height - 150) / 2, width: 150, height: 150)
        self.tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    private func bind() -> Void {
        
        self.albums.removeAll()
        
        albumViewModel.getUsersSavedAlbums
            .observe(on: MainScheduler.instance)
            .bind { [weak self] albums in
                guard let album: Albums = albums else { return }
                
                self?.albums = album.items.compactMap { $0.album }
                self?.updateUI()
            }.disposed(by: self.bag)
    }
    
    private func updateUI() -> Void {
        
        if (self.albums.isEmpty == true) {
            /// Show Label
             actionLabelView.isHidden = false
            self.tableView.isHidden = true
        } else {
            /// Show Table
            self.tableView.reloadData()
            actionLabelView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    private func updatePlaylists() -> Void {
        
        APICaller.shared.getUsersSavedAlbums()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] albums in
                self?.albums = albums.items.compactMap({ $0.album })
                self?.updateUI()
            }, onError: { error in
                print("error: \(error.localizedDescription)")
            }).disposed(by: albumViewModel.bag)
    }
    
    // MARK: - Event Handler Method
    @objc private func didTapClose(_ sender: UIBarButtonItem) -> Void {
        
        self.dismiss(animated: true)
    }
}

// MARK: - Extension ViewController
extension LibraryAlbumsViewController: ActionLabelViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - ActionLabelViewDelegate Method Implementation
    func actionLabelViewDidTapButton(actionView: ActionLabelView) {
        
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: - UITableViewDataSource Methods
    /// Required Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: SearchResultSubTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else { return UITableViewCell() }
        
        cell.configureSearchResultSubTitleViewCell(args: albums[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    // MARK: - ActionLabelViewDelegate Methods
    /// Optional Method.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        guard let album = self.albums[indexPath.row] else { return }
        
        let playlistVC: AlbumViewController = AlbumViewController(item: album)
        
        self.navigationController?.pushViewController(playlistVC, animated: true)
    }
}
