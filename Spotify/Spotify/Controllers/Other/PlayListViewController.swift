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
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        return PlaylistViewController.configureCollectionViewLayout()
    }))
    
    // MARK: - Stored-Props
    private let playlistItem: CommonGroundModel.SimplifiedPlaylist
    
    private let playlistsViewModel: PlaylistsViewModel = PlaylistsViewModel()
    private var bag: DisposeBag = DisposeBag(), disposeBag: DisposeBag = DisposeBag()
    
    private var playlistTracks: [Playlist.Track.PlaylistTrack] = [Playlist.Track.PlaylistTrack]()
    private var tracks: [TrackObject] = [TrackObject]()
    
    // MARK: - Inits
    init(item: CommonGroundModel.SimplifiedPlaylist) {
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
        defaultConfigurePlaylistViewController(with: playlistItem)
        
        view.addSubview(self.collectionView)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        bind()
        configureCollectionView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare(_:)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = view.bounds
    }
    
    private func defaultConfigurePlaylistViewController(with item: CommonGroundModel.SimplifiedPlaylist) -> Void {
        
        view.backgroundColor = .systemBackground
        
        title = item.name
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func addObserver() -> Void {
        
        APICaller.shared.getPlaylist(for: playlistItem)
            .subscribe { [weak self] playlist in
                self?.playlistsViewModel.playlist.onNext(playlist)
            } onError: { error in
                self.playlistsViewModel.playlist.onError(error)
            }.disposed(by: playlistsViewModel.bag)
    }
    
    private func bind() -> Void {
        
        disposeBag = DisposeBag()   //  중복구독 방지 (-> 이전의 구독 취소)
        
        addObserver()
        
        playlistsViewModel.playlist
            .observe(on: MainScheduler.instance)
            .bind { [weak self] playlist in
                guard let _: PlaylistViewController = self else { return }
                
                self?.playlistTracks = playlist.tracks.items
                self?.tracks = playlist.tracks.items.compactMap({ $0.track })
                self?.collectionView.reloadData()
            }.disposed(by: self.bag)
    }
    
    private static func configureCollectionViewLayout() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 1.0
        
        let supplementaryItem: [NSCollectionLayoutBoundarySupplementaryItem] = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            ),
            subitem: item,
            count: 1)
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = supplementaryItem
        
        return section;
    }
    
    private func configureCollectionView() -> Void {
        
        self.collectionView.backgroundColor = .systemBackground
        
        self.collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        self.collectionView.register(RecommendationCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
    }
    
    // MARK: - Event Handler Method
    @objc private func didTapShare(_ sender: UIBarButtonItem) -> Void {
        
        guard let url: URL = URL(string: playlistItem.external_urls.spotify) else { return }
        
        let vc: UIActivityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

// MARK: - Extension ViewController
extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource, PlaylistHeaderCollectionReusableViewDelegate {
    
    // MARK: - UICollectionViewDataSource Methods
    ///  Required Methods.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return playlistTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: RecommendationCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendationCollectionViewCell.identifier,
            for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureRecommendationCollectionViewCell(args: playlistTracks[indexPath.row])
        
        return cell
    }
    
    ///  Optional Methods.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header: PlaylistHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath) as? PlaylistHeaderCollectionReusableView,
              (kind == UICollectionView.elementKindSectionHeader) else {
            return UICollectionReusableView()
        }
        
        header.configurePlaylistHeader(args: playlistItem)
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index: Int = indexPath.row
        let track: TrackObject = tracks[index]
        
        PlaybackPresenter.startPlayback(from: self, data: track)
    }
    
    // MARK: - PlaylistHeaderCollectionReusableViewDelegate Method Implementation
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(header: PlaylistHeaderCollectionReusableView) {
        
        PlaybackPresenter.startPlayback(from: self, data: tracks)
    }
}
