//
//  SearchViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import SafariServices

class SearchViewController: UIViewController {
    
    // MARK: - View Controller
    let searchController: UISearchController = {
        
        let searchController: UISearchController = UISearchController(searchResultsController: SearchResultsViewController()).then {
            $0.searchBar.placeholder = "What do you want to listen to?"
            $0.searchBar.searchBarStyle = .minimal
            $0.definesPresentationContext = true
        }
        
        return searchController
    }()
    
    // MARK: - UI Component
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                return configureCollectionViewLayout()
            }))
    
    // MARK: - Stored-Props
    private var categories: [CommonGroundModel.Category] = [CommonGroundModel.Category]()
    
    private let playlistsViewModel: PlaylistsViewModel = PlaylistsViewModel()
    private let categoriesViewModel: CategoriesViewModel = CategoriesViewModel()
    private let searchViewModel: SearchViewModel = SearchViewModel()
    private var bag: DisposeBag = DisposeBag()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        defaultConfigureSearchViewController()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .systemBackground
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        configureCollectionView()
        
        bind(first_args: categoriesViewModel, second_args: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = view.bounds
    }
    
    private func defaultConfigureSearchViewController() -> Void {
        
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func bind<T>(first_args firstParams: T, second_args SecondParams: UIViewController?) -> Void {
        
        switch firstParams {
        case let categoriesViewModel as CategoriesViewModel:
            categoriesViewModel.categories
                .observe(on: MainScheduler.instance)
                .bind { [weak self] severalBrowseCategories in
                    self?.categories = severalBrowseCategories?.categories.items ?? []
                    self?.collectionView.reloadData()
                }.disposed(by: self.bag)
            break;
        case let searchViewModel as SearchViewModel:
            searchViewModel.searchResults
                .observe(on: MainScheduler.instance)
                .bind { [weak self] searchResults in
                    if let searchResultsVC: SearchResultsViewController = SecondParams as? SearchResultsViewController {
                        searchResultsVC.update(args: searchResults)
                    }
                }.disposed(by: self.bag)
            break;
        default:
            break;
        }
    }
    
    private static func configureCollectionViewLayout() -> NSCollectionLayoutSection {
        
        /// Item
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5)
        
        /// Group
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(130)),
            subitem: item,
            count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        /// Section
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureCollectionView() -> Void {
        
        self.collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        view.addSubview(self.collectionView)
    }
}

// MARK: - Extension ViewController
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, SearchResultsViewControllerDelegate {
    
    // MARK: - UICollectionViewDelegate Method
    ///  Optional Method.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let categoryVC: CategoryViewController = CategoryViewController(category: self.categories[indexPath.row])
        
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource Method
    ///  Required Methods.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCategoryCollectionViewCell(args: categories[indexPath.row])
        
        return cell
    }
    
    ///  Optional Method.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    // MARK: - UISearchResultsUpdating Methods
    ///  Required Method.
    func updateSearchResults(for searchController: UISearchController) {}
    
    // MARK: - UISearchBarDelegate Method
    ///  Optional Method.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchResultsVC: SearchResultsViewController = searchController.searchResultsController as? SearchResultsViewController,
              let query: String = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        searchResultsVC.delegate = self
        
        //  Perform Search
        addObserver(args: query)
        bind(first_args: searchViewModel, second_args: searchResultsVC)
    }
    
    private func addObserver(args query: String) -> Void {
        
        var searchResults: [SearchResult] = []
        
        APICaller.shared.searchForItem(args: query)
            .subscribe { [weak self] searchResponse in
                self?.searchViewModel.search.onNext(searchResponse)
                
                searchResults.append(contentsOf: searchResponse.tracks?.items.compactMap({ SearchResult.track(track: $0) }) ?? [])
                searchResults.append(contentsOf: searchResponse.artists?.items.compactMap({ SearchResult.artist(artist: $0) }) ?? [])
                searchResults.append(contentsOf: searchResponse.albums?.items.compactMap({ SearchResult.album(album: $0) }) ?? [])
                searchResults.append(contentsOf: searchResponse.playlists?.items.compactMap({ SearchResult.playlist(playlist: $0) }) ?? [])
                searchResults.append(contentsOf: searchResponse.shows?.items.compactMap({ SearchResult.show(show: $0) }) ?? [])
                searchResults.append(contentsOf: searchResponse.audiobooks?.items.compactMap({ SearchResult.audiobook(audiobook: $0) }) ?? [])
                
                self?.searchViewModel.searchResults.onNext(searchResults)
            } onError: { error in
                self.searchViewModel.search.onError(error)
            }.disposed(by: searchViewModel.bag)
    }
    
    // MARK: - SearchResultsViewControllerDelegate Method Implementation
    func didTapResult(args result: SearchResult) {
        
        var sfSafariVC: SFSafariViewController
        
        switch result {
        case .track(track: let track):
            PlaybackPresenter.shared.startPlayback(from: self, data: track)
            break;
        case .artist(artist: let artist):
            guard let external_urls: URL = URL(string: artist?.external_urls.spotify ?? "") else { return }
            
            sfSafariVC = SFSafariViewController(url: external_urls)
            self.present(sfSafariVC, animated: true)
            break;
        case .album(album: let album):
            guard let album: CommonGroundModel.SimplifiedAlbum = album else { return }
            let albumVC: AlbumViewController = AlbumViewController(item: album)
            
            navigationController?.pushViewController(albumVC, animated: true)
            break;
        case .playlist(playlist: let playlist):
            guard let playlist: CommonGroundModel.SimplifiedPlaylist = playlist else { return }
            let playlistVC: PlaylistViewController = PlaylistViewController(item: playlist)
            
            navigationController?.pushViewController(playlistVC, animated: true)
            break;
        case .show(show: let show):
            guard let external_urls: URL = URL(string: show?.external_urls.spotify ?? "") else { return }
            
            sfSafariVC = SFSafariViewController(url: external_urls)
            self.present(sfSafariVC, animated: true)
            break;
        case .audiobook(audiobook: _):
            break;
        }
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct SearchViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        SearchViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct SearchViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            SearchViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
