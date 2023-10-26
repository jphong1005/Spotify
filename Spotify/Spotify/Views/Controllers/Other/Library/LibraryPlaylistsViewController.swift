//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by 홍진표 on 10/22/23.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class LibraryPlaylistsViewController: UIViewController {

    // MARK: - UI Components
    private let actionLabelView: ActionLabelView = ActionLabelView()
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(SearchResultSubTitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        $0.isHidden = true
    }
    
    // MARK: - Stored-Props
    private let playlistsViewModel: PlaylistsViewModel = PlaylistsViewModel()
    private var bag: DisposeBag = DisposeBag()
//    , disposeBag: DisposeBag = DisposeBag()
    
    private var playlists: [CommonGroundModel.SimplifiedPlaylist?] = []
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    private func defaultConfigureLibraryPlaylistsViewController() -> Void {
        
        view.backgroundColor = .systemBackground
        
        actionLabelView.configureActionLabelView(first_args: "You don't have any playlists yet.", second_args: "CREATE")
    }
    
    private func configureLibraryPlaylistsViewController() -> Void {
        
        view.addSubview(actionLabelView)
        view.addSubview(self.tableView)
    }
    
    private func frameBasedLayout() -> Void {
        
        actionLabelView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        actionLabelView.center = view.center
        
        self.tableView.frame = self.view.bounds
    }
    
    private func observing(args playlistName: String) -> Void {
        
        let observer: Observable<Playlists.Playlist> = APICaller.shared.createPlaylist(args: playlistName)
            .flatMap { _ in
                return APICaller.shared.getCurrentUsersPlaylists()
            }
        
        observer
            .subscribe { [weak self] playlist in
                self?.playlistsViewModel.getCurrentUsersPlaylists.onNext(playlist)
            } onError: { error in
                self.playlistsViewModel.getCurrentUsersPlaylists.onError(error)
            }.disposed(by: playlistsViewModel.bag)

    }
    
    private func bind() -> Void {
        
        playlistsViewModel.getCurrentUsersPlaylists
            .observe(on: MainScheduler.instance)
            .bind { [weak self] playlists in
                self?.playlists = playlists?.items ?? []
                self?.updateUI()
            }.disposed(by: self.bag)
    }
    
    private func updateUI() -> Void {
        
        if (self.playlists.isEmpty == true) {
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
    
    public func showCreatePlaylistsAlert() -> Void {
        
        /// Show Creation UI
        let alert: UIAlertController = UIAlertController(title: "New Playlists", message: "Enter playlist name.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Playlist"
        }
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
        alert.addAction(UIAlertAction(title: "CREATE", style: .default, handler: { _ in
            guard let textField: UITextField = alert.textFields?.first,
                    let text = textField.text,
                    !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            self.observing(args: text)
        }))
        
        self.present(alert, animated: true)
    }
}

// MARK: - Extension ViewController
extension LibraryPlaylistsViewController: ActionLabelViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - ActionLabelViewDelegate Method Implementation
    func actionLabelViewDidTapButton(actionView: ActionLabelView) {
        
        showCreatePlaylistsAlert()
    }
    
    // MARK: - UITableViewDataSource Methods
    ///  Required Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: SearchResultSubTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else { return UITableViewCell() }
        
        cell.configureSearchResultSubTitleViewCell(args: playlists[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    // MARK: - ActionLabelViewDelegate Methods
}
