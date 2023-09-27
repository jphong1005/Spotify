//
//  PlayListViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import RxSwift
import RxCocoa

class PlaylistViewController: UIViewController {

    // MARK: - UI Component
    private let collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                    collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        return PlaylistViewController.configureSectionLayout()
    }))
    
    // MARK: - Stored-Props
    private let playlistItem: FeaturedPlaylists.PlayList.SimplifiedPlaylist
    private let spotifyViewModel: SpotifyViewModel = SpotifyViewModel()
    private var bag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var tracks: [Playlist.Track.PlaylistTrack] = [Playlist.Track.PlaylistTrack]()
    
    // MARK: - Inits
    init(item: FeaturedPlaylists.PlayList.SimplifiedPlaylist) {
        playlistItem = item
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
        
        configurePlaylistViewController(with: playlistItem)
        
        view.addSubview(collectionView)
        
        configureCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //APICaller.shared.getPlaylist(for: playlistItem)
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func bind() -> Void {
        
        disposeBag = DisposeBag()   //  중복구독 방지 (-> 이전의 구독 취소)
        
        addObserver()
        
        spotifyViewModel.playlists.playlist
            .observe(on: MainScheduler.instance)
            .bind { [weak self] playlist in
                guard let _: PlaylistViewController = self else { return }
                
                self?.tracks = playlist.tracks.items
                self?.collectionView.reloadData()
            }.disposed(by: self.bag)
    }
    
    private func addObserver() -> Void {
        
        APICaller.shared.getPlaylist(for: playlistItem)
            .subscribe { [weak self] playlist in
                self?.spotifyViewModel.playlists.playlist.onNext(playlist)
            } onError: { error in
                self.spotifyViewModel.playlists.playlist.onError(error)
            }.disposed(by: spotifyViewModel.playlists.bag)
    }
    
    private func configurePlaylistViewController(with item: FeaturedPlaylists.PlayList.SimplifiedPlaylist) -> Void {
        
        title = item.name
    }
    
    private static func configureSectionLayout() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 1.0
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            ),
            subitem: item,
            count: 1)
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        
        return section;
    }
    
    private func configureCollectionView() -> Void {
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RecommendationCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource Methods
    ///  Required Methods.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, 
                                                            for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureRecommendationCollectionViewCell(playlist: tracks[indexPath.row], recommendation: nil)
        
        return cell
    }
    
    ///  Optional Methods.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
