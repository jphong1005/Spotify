//
//  SearchViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import Then

class SearchViewController: UIViewController {
    
    // MARK: - View Controller
    let searchController: UISearchController = {
        
        let searchController: UISearchController = UISearchController(searchResultsController: SearchResultsViewController()).then {
            $0.searchBar.placeholder = "Songs, Artists, Albums"
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
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        defaultConfigureSearchViewController()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .systemBackground
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        configureCollectionView()
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
    
    private static func configureCollectionViewLayout() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 1.0
        
        /// Item
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        /// Group
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)),
            subitem: item,
            count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        /// Section
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureCollectionView() -> Void {
        
        view.addSubview(self.collectionView)
        
        self.collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
    }
}

// MARK: - Extension ViewController
extension SearchViewController: UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UISearchResultsUpdating Methods
    ///  Required Method.
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchResultsVC: SearchResultsViewController = searchController.searchResultsController as? SearchResultsViewController,
              let query: String = searchController.searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        //  Perform Search
    }
    
    // MARK: - UICollectionViewDelegate Method
    
    // MARK: - UICollectionViewDataSource Method
    ///  Required Method.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: GenreCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureGenreCollectionViewCell(args: "Genre")
        
        return cell
    }
    
    ///  Optional Method.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
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
