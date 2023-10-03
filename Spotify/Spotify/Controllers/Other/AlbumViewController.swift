//
//  AlbumViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumViewController: UIViewController {
    
    // MARK: - UI Component
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        return AlbumViewController.configureSectionLayout()
    }))
    
    // MARK: - Stored-Props
    private let albumItem: CommonGround.SimplifiedAlbum
    private var album: Album? = nil
    
    private let spotifyViewModel: SpotifyViewModel = SpotifyViewModel()
    private var bag: DisposeBag = DisposeBag(), disposeBag: DisposeBag = DisposeBag()
    
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
        defaultConfigureAlbumViewController(with: albumItem)
        
        view.addSubview(self.collectionView)
        
        configureCollectionView()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = view.bounds
    }
    
    private func defaultConfigureAlbumViewController(with albumItem: CommonGround.SimplifiedAlbum) -> Void {
        
        view.backgroundColor = .systemBackground
        
        title = albumItem.name
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bind() -> Void {
        
        disposeBag = DisposeBag()   //  중복구독 방지
        
        addObserver()
        
        spotifyViewModel.album.album
            .observe(on: MainScheduler.instance)
            .bind { [weak self] album in    //  Get Album
                guard let _: AlbumViewController = self else { return }
                
                self?.album = album
                self?.collectionView.reloadData()
            }.disposed(by: self.bag)
    }
    
    private func addObserver() -> Void {
        
        APICaller.shared.getAlbum(for: albumItem)
            .subscribe { [weak self] album in
                self?.spotifyViewModel.album.album
                    .onNext(album)
            } onError: { error in
                self.spotifyViewModel.album.album
                    .onError(error)
            }.disposed(by: spotifyViewModel.album.bag)
    }
    
    private static func configureSectionLayout() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 1.0
        
        let supplementaryItem: [NSCollectionLayoutBoundarySupplementaryItem] = [
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        
        /// Item
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        /// Group
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            ),
            subitem: item,
            count: 1
        )
        
        /// Section
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = supplementaryItem
        
        return section
    }
    
    private func configureCollectionView() -> Void {
        
        self.collectionView.backgroundColor = .systemBackground
        
        self.collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        self.collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
    }
}

// MARK: - Extension ViewController
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, PlaylistHeaderCollectionReusableViewDelegate {
    
    // MARK: - UICollectionViewDataSource Methods
    ///  Required Methods.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return albums.count
        return album?.tracks.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: AlbumTrackCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
            for: indexPath) as? AlbumTrackCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureAlbumTrackCollectionViewCell(args: album?.tracks.items[indexPath.row])
        
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
        
        header.configurePlaylistHeader(args: album)
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - PlaylistHeaderCollectionReusableViewDelegate Method Implementation
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(header: PlaylistHeaderCollectionReusableView) {
        
        //  Start playlist play in queue
        print("Playing All")
    }
}
