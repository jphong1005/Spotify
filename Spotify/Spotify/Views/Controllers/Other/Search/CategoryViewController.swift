//
//  CategoryViewController.swift
//  Spotify
//
//  Created by 홍진표 on 10/5/23.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController {

    // MARK: - UI Component
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                return configureCollectionViewLayout()
            }))
    
    // MARK: - Stored-Props
    let category: CommonGroundModel.Category
    private var playlists: [CommonGroundModel.SimplifiedPlaylist] = [CommonGroundModel.SimplifiedPlaylist]()
    
    private let playlistsViewModel: PlaylistsViewModel = PlaylistsViewModel()
    private var bag: DisposeBag = DisposeBag(), disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Inits
    init(category: CommonGroundModel.Category) {
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = category.name
        
        defaultCategoryViewController()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        configureCollectionView()
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = view.bounds
    }
    
    private func defaultCategoryViewController() -> Void {
        
        view.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func addObserver() -> Void {
        
        Task {
            do {
                try await APICaller.shared.getCategoryPlaylists(args: category).value
                    .subscribe { [weak self] playlists in
                        self?.playlistsViewModel.categoryPlaylists.onNext(playlists)
                    } onError: { error in
                        self.playlistsViewModel.categoryPlaylists.onError(error)
                    }.disposed(by: playlistsViewModel.bag)
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    private func bind() {
        
        disposeBag = DisposeBag()
        
        addObserver()
        
        playlistsViewModel.categoryPlaylists
            .observe(on: MainScheduler.instance)
            .bind { [weak self] playlists in
                self?.playlists = playlists.playlists.items.compactMap { $0 }
                self?.collectionView.reloadData()
            }.disposed(by: self.bag)
    }
    
    private static func configureCollectionViewLayout() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5.0
        
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
                heightDimension: .absolute(250)),
            subitem: item,
            count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        /// Section
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureCollectionView() -> Void {
        
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        
        view.addSubview(self.collectionView)
    }
}

// MARK: - Extension ViewController
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegate Method
    ///  Optional Method.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let playlistViewController: PlaylistViewController = PlaylistViewController(item: playlists[indexPath.row])
        
        navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource Method
    ///  Required Methods.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: FeaturedPlaylistCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureFeaturedPlaylistCollectionViewCellUI(args: playlists[indexPath.row])
        
        return cell
    }
}
