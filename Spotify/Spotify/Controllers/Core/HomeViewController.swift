//
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
    
    enum HomeSectionType {
        case newReleases(newReleases: NewReleasesResponse?)
        case featuredPlaylists(playlists: FeaturedPlayListsResponse?)
        case recommendations(tracks: RecommendationsResponse?)
    }
    
    // MARK: - UI Components
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIdx, _ in
        return HomeViewController.configureSectionLayout(section: sectionIdx)
    }))
    
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.tintColor = .label
        $0.hidesWhenStopped = true
    }
    
    // MARK: - Stored-Props
    private var sections: [HomeSectionType] = [HomeSectionType]()
    
    private let spotifyViewModel: SpotifyViewModel = SpotifyViewModel()
    private var bag: DisposeBag = DisposeBag()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        
        self.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        bind()
        
        configureCollectionView()
        navigationBarUI()
        
        view.addSubview(spinner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func bind() -> Void {
        
        /// 각 ViewModel의 Property를 관찰하는 Observable 선언 및 초기화
        let newReleasesObservable: BehaviorSubject<NewReleasesResponse?> = self.spotifyViewModel.albums.newReleases
        let featuredPlaylistsObservable: BehaviorSubject<FeaturedPlayListsResponse?> = self.spotifyViewModel.playlists.featuredPlaylist
        let recommendationsObservable: BehaviorSubject<RecommendationsResponse?> = self.spotifyViewModel.tracks.recommendations
        
        /// Observables를 결합
        let combinedObservable: Observable<(NewReleasesResponse?, FeaturedPlayListsResponse?, RecommendationsResponse?)> = Observable.combineLatest(newReleasesObservable, featuredPlaylistsObservable, recommendationsObservable)    //  Data Stream을 하나로 통합 -> Data의 수신 시점이 다른 문제를 해결할수 있음!
        
        self.updateSectionsWhenDataArrives(combinedObservable: combinedObservable)
    }
    
    /// SOLID의 '단일 책임 원칙 (= SRP)'에 의거하여 메서드를 분리
    private func updateSectionsWhenDataArrives(combinedObservable: Observable<(NewReleasesResponse?, FeaturedPlayListsResponse?, RecommendationsResponse?)>) -> Void {
        
        combinedObservable
            .observe(on: MainScheduler.instance)
            .bind { [weak self] (newReleasesResponse, featuredPlaylistsResponse, recommendationsResponse) in
                
                //  모든 Observable에서 데이터가 도착했으면 아래 블록 실행
                guard newReleasesResponse != nil, featuredPlaylistsResponse != nil, recommendationsResponse != nil else { return }
                
                self?.sections.append(.newReleases(newReleases: newReleasesResponse))
                self?.sections.append(.featuredPlaylists(playlists: featuredPlaylistsResponse))
                self?.sections.append(.recommendations(tracks: recommendationsResponse))
                
                self?.collectionView.reloadData()
            }.disposed(by: self.bag)
    }
    
    private func navigationBarUI() -> Void {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings(_:)))
    }
    
    private static func configureSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 1.0
        
        switch section {
        case 0:
            //  Item
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            //  Groups   (-> Vertical group in horizontal group)
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
            
            //  Section
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: horizontalGroup)
            
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
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .systemBackground
    }
    
    @objc func didTapSettings(_ sender: UIBarButtonItem) -> Void {
        
        let settingsVC: SettingsViewController = SettingsViewController()
        
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource Methods
    ///  Required Methods.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionTypes: HomeViewController.HomeSectionType = sections[section]
        
        switch sectionTypes {
        case .newReleases(let newReleasesResponse):
            guard let newReleases: NewReleasesResponse = newReleasesResponse else { return 0 }
            
            return newReleases.albums.items.count
        case .featuredPlaylists(let featuredPlaylistsResponse):
            guard let playlists: FeaturedPlayListsResponse = featuredPlaylistsResponse else { return 0 }
            
            return playlists.playlists.items.count
        case .recommendations(let reccomendationsResponse):
            guard let reccomendations: RecommendationsResponse = reccomendationsResponse else { return 0 }
            
            return reccomendations.tracks.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType: HomeViewController.HomeSectionType = sections[indexPath.section]
        
        switch sectionType {
        case .newReleases(let newReleasesResponse):
            guard let cell: NewReleasesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else { return UICollectionViewCell() }
            
            guard let item: NewReleasesResponse.Album.SimplifiedAlbum = newReleasesResponse?.albums.items[indexPath.row] else { return UICollectionViewCell() }
            
            cell.configureNewReleaseCollectionViewCellUI(value: item)
            
            return cell;
        case .featuredPlaylists(let featuredPlaylistsResponse):
            guard let cell: FeaturedPlaylistCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else { return UICollectionViewCell() }
            
            guard let item: PlayList.SimplifiedPlaylist = featuredPlaylistsResponse?.playlists.items[indexPath.row] else { return UICollectionViewCell() }
            
            cell.configureFeaturedPlaylistCollectionViewCellUI(value: item)
            
            return cell;
        case .recommendations(let recommendationsResponse):
            guard let cell: RecommendationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell() }
            
            guard let track: Track = recommendationsResponse?.tracks[indexPath.row] else { return UICollectionViewCell() }
            
            cell.configureRecommendationCollectionViewCell(value: track)
            
            return cell;
        }
    }
    
    ///  Optional Methods.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let sectionType: HomeViewController.HomeSectionType = sections[indexPath.section]
        
        switch sectionType {
        case .newReleases(let newReleasesResponse):
            guard let albumItem: NewReleasesResponse.Album.SimplifiedAlbum = newReleasesResponse?.albums.items[indexPath.row] else { return }
            let albumVC: AlbumViewController = AlbumViewController(item: albumItem)
            
            self.navigationController?.pushViewController(albumVC, animated: true)
            break;
        case .featuredPlaylists(let featuredPlaylistsResponse):
            guard let playlistItem: PlayList.SimplifiedPlaylist = featuredPlaylistsResponse?.playlists.items[indexPath.row] else { return }
            let playlistVC: PlaylistViewController = PlaylistViewController(item: playlistItem)
            
            self.navigationController?.pushViewController(playlistVC, animated: true)
            break;
        case .recommendations(let recommendationsResponse):
            break;
        default:
            break;
        }
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
