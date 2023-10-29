 
//  ViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIdx, _ in
        return HomeViewController.configureCollectionViewLayout(section: sectionIdx)
    }))
    
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.tintColor = .label
        $0.hidesWhenStopped = true
    }
    
    // MARK: - Stored-Props
    private var sections: [HomeSectionType] = [HomeSectionType]()
    
    private let newReleasesViewModel: NewReleasesViewModel = NewReleasesViewModel()
    private let playlistsViewModel: PlaylistsViewModel = PlaylistsViewModel()
    private let tracksViewModel: TracksViewModel = TracksViewModel()
    private var bag: DisposeBag = DisposeBag()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaultConfigureHomeViewController()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .systemBackground
        
        bind()
        
        configureCollectionView()
        navigationBarUI()
        
        view.addSubview(spinner)
        
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = view.bounds
    }
    
    private func defaultConfigureHomeViewController() -> Void {
        
        view.backgroundColor = .systemBackground
        
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func bind() -> Void {
        
        /// 각 ViewModel의 Property를 관찰하는 Observable 선언 및 초기화
        let newReleasesObservable: BehaviorSubject<NewReleases?> = self.newReleasesViewModel.newReleases
        let featuredPlaylistsObservable: BehaviorSubject<Playlists?> = self.playlistsViewModel.featuredPlaylists
        let recommendationsObservable: BehaviorSubject<Recommendations?> = self.tracksViewModel.recommendations
        
        /// Observables를 결합 -> Data Stream을 하나로 통합 (= Data의 수신 시점이 다른 문제를 해결)
        let combinedObservable: Observable<(NewReleases?, Playlists?, Recommendations?)> = Observable.combineLatest(newReleasesObservable, featuredPlaylistsObservable, recommendationsObservable)
        
        combinedObservable.observe(on: MainScheduler.instance)
            .bind { [weak self] (newReleasesResponse, featuredPlaylistsResponse, recommendationsResponse) in
                /// 모든 Observable에서 데이터가 도착했으면 아래 블록 실행
                guard newReleasesResponse != nil, featuredPlaylistsResponse != nil, recommendationsResponse != nil else { return }
                
                let newReleases_albums_items: [CommonGroundModel.SimplifiedAlbum]? = newReleasesResponse?.albums.items.compactMap({ return $0 })
                let featuredPlaylists_playlists_items: [CommonGroundModel.SimplifiedPlaylist]? = featuredPlaylistsResponse?.playlists.items.compactMap({ return $0 })
                let recommendations_tracks: [TrackObject]? = recommendationsResponse?.tracks.compactMap({ return $0.preview_url != nil ? $0 : nil })
                
                self?.sections.append(.newReleases(albums_items: newReleases_albums_items))
                self?.sections.append(.featuredPlaylists(playlists_items: featuredPlaylists_playlists_items))
                self?.sections.append(.recommendations(tracks: recommendations_tracks))
                
                self?.collectionView.reloadData()
            }.disposed(by: self.bag)
    }
    
    private static func configureCollectionViewLayout(section: Int) -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 1.0
        
        let supplementaryItem: [NSCollectionLayoutBoundarySupplementaryItem] = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        switch section {
        case 0:
            /// Item
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            /// Groups   (-> Vertical group in horizontal group)
            let verticalGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(350)
                ),
                subitem: item,
                count: 3)
            let horizontalGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(350)
                ),
                subitem: verticalGroup,
                count: 1)
            
            /// Section
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: horizontalGroup)
            
            section.boundarySupplementaryItems = supplementaryItem
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section;
        case 1:
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            let verticalGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2)
            let horizontalGroup: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1)
            
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: horizontalGroup)
            
            section.boundarySupplementaryItems = supplementaryItem
            section.orthogonalScrollingBehavior = .continuous
            
            return section;
        case 2:
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
            
            section.boundarySupplementaryItems = supplementaryItem
            
            return section;
        default:
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 1)
            
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section;
        }
    }
    
    private func configureCollectionView() -> Void {
        
        view.addSubview(self.collectionView)
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        self.collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        self.collectionView.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
        
        self.collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
    }
    
    private func navigationBarUI() -> Void {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings(_:)))
    }
    
    private func addLongTapGesture() -> Void {
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.addGestureRecognizer(gesture)
    }
    
    // MARK: - Event Handler Method
    @objc func didTapSettings(_ sender: UIBarButtonItem) -> Void {
        
        let settingsVC: SettingsViewController = SettingsViewController()
        
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) -> Void {
        
        guard sender.state == .began else { return }
        
        let touchPoint: CGPoint = sender.location(in: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: touchPoint),
                indexPath.section == 2 else { return }
        
        do {
            let trackObjects = try self.tracksViewModel.recommendations.value()?.tracks.compactMap({ return $0.preview_url != nil ? $0 : nil })
            guard let trackObject: TrackObject = trackObjects?[indexPath.row] else { return }
            let actionSheet: UIAlertController = UIAlertController(title: trackObject.name,
                                                                   message: "Would you like to add this to a playlist?",
                                                                   preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
            actionSheet.addAction(UIAlertAction(title: "ADD TO PLAYLIST", style: .default, handler: { [weak self] _ in
                DispatchQueue.main.async {
                    let libraryPlaylistsVC: LibraryPlaylistsViewController = LibraryPlaylistsViewController()
                    
                    libraryPlaylistsVC.selectionHandler = { playlist in
                        APICaller.shared.addItemsToPlaylist(first_args: trackObject, second_args: playlist)
                            .subscribe(onDisposed: {
                                print("SUCCESS")
                            })
                    }
                    
                    libraryPlaylistsVC.title = "Select Playlist"
                    self?.present(UINavigationController(rootViewController: libraryPlaylistsVC), animated: true)
                }
            }))
            
            self.present(actionSheet, animated: true )
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}

// MARK: - Extension ViewController
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegate Method
    /// Optional Methods.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let sectionType: HomeSectionType = sections[indexPath.section]
        
        switch sectionType {
        case .newReleases(let newReleases):
            guard let albumItem: CommonGroundModel.SimplifiedAlbum = newReleases?[indexPath.row] else { return }
            
            let albumVC: AlbumViewController = AlbumViewController(item: albumItem)
            
            navigationController?.pushViewController(albumVC, animated: true)
            break;
        case .featuredPlaylists(let featuredPlaylists):
            guard let playlistItem: CommonGroundModel.SimplifiedPlaylist = featuredPlaylists?[indexPath.row] else { return }
            
            let playlistVC: PlaylistViewController = PlaylistViewController(item: playlistItem)
            
            navigationController?.pushViewController(playlistVC, animated: true)
            break;
        case .recommendations(let recommendations):
            guard let recommendationItem: TrackObject = recommendations?[indexPath.row] else { return }
            
            PlaybackPresenter.shared.startPlayback(from: self, data: recommendationItem)
            break;
        }
    }
    
    // MARK: - UICollectionViewDataSource Methods
    ///  Required Methods.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionTypes: HomeSectionType = sections[section]
        
        switch sectionTypes {
        case .newReleases(let newReleases): return newReleases?.count ?? 0
        case .featuredPlaylists(let featuredPlaylists): return featuredPlaylists?.count ?? 0
        case .recommendations(let recommendations): return recommendations?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType: HomeSectionType = sections[indexPath.section]
        
        switch sectionType {
        case .newReleases(let newReleases):
            guard let cell: NewReleasesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else { return UICollectionViewCell() }
            guard let item: CommonGroundModel.SimplifiedAlbum = newReleases?[indexPath.row] else { return UICollectionViewCell() }
            
            cell.configureNewReleaseCollectionViewCellUI(value: item)
            
            return cell
        case .featuredPlaylists(let featuredPlaylists):
            guard let cell: FeaturedPlaylistCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else { return UICollectionViewCell() }
            guard let item: CommonGroundModel.SimplifiedPlaylist = featuredPlaylists?[indexPath.row] else { return UICollectionViewCell() }
            
            cell.configureFeaturedPlaylistCollectionViewCellUI(args: item)
            
            return cell
        case .recommendations(let recommendations):
            guard let cell: RecommendationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell() }
            guard let track: TrackObject = recommendations?[indexPath.row] else { return UICollectionViewCell() }
            
            cell.configureRecommendationCollectionViewCell(args: track)
            
            return cell
        }
    }
    
    ///  Optional Methods.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header: TitleHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
            for: indexPath) as? TitleHeaderCollectionReusableView, (kind == UICollectionView.elementKindSectionHeader) else { return UICollectionViewCell() }
        
        header.configureTitleHeader(args: sections[indexPath.section].headerTitle)
        
        return header
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct HomeViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct HomeViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            HomeViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
