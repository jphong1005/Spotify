//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import Then
import RxSwift
import RxCocoa

protocol SearchResultsViewControllerDelegate: AnyObject {
    
    // MARK: - Function Prototype
    func didTapResult(args result: SearchResult) -> Void
}

class SearchResultsViewController: UIViewController {

    // MARK: - UI Component
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .systemBackground
        $0.register(DefaultSearchResultTableViewCell.self, forCellReuseIdentifier: DefaultSearchResultTableViewCell.identifier)
        $0.register(SearchResultSubTitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubTitleTableViewCell.identifier)
        $0.isHidden = true
    }
    
    // MARK: - Stored-Props
    private var sections: [SearchSection] = []
    weak var delegate: SearchResultsViewControllerDelegate?

    private let searchViewModel: SearchViewModel = SearchViewModel()
    private var bag: DisposeBag = DisposeBag()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultSearchResultsViewController()
        
        view.addSubview(self.tableView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = view.bounds
    }
    
    private func defaultSearchResultsViewController() -> Void {
        
        view.backgroundColor = .clear
    }
    
    public func update(args results: [SearchResult]) -> Void {
        
        self.sections = [
            SearchSection(sectionHeaderTitle: "Tracks", results: results.filter({ result in
                if case SearchResult.track(track: _) = result {
                    return true
                }
                return false
            })),
            SearchSection(sectionHeaderTitle: "Artists", results: results.filter({ result in
                if case SearchResult.artist(artist: _) = result {
                    return true
                }
                return false
            })),
            SearchSection(sectionHeaderTitle: "Albums", results: results.filter({ result in
                if case SearchResult.album(album: _) = result {
                    return true
                }
                return false
            })),
            SearchSection(sectionHeaderTitle: "Playlists", results: results.filter({ result in
                if case SearchResult.playlist(playlist: _) = result {
                    return true
                }
                return false
            })),
            SearchSection(sectionHeaderTitle: "Shows", results: results.filter({ result in
                if case SearchResult.show(show: _) = result {
                    return true
                }
                return false
            })),
            SearchSection(sectionHeaderTitle: "Audiobooks", results: results.filter({ result in
                if case SearchResult.audiobook(audiobook: _) = result {
                    return true
                }
                return false
            }))
        ]
        
        self.tableView.reloadData()
        self.tableView.isHidden = results.isEmpty
    }
}

// MARK: - Extension ViewController
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Method
    ///  Required Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult: SearchResult = sections[indexPath.section].results[indexPath.row]
        
        switch searchResult {
        case .track(let track):
            guard let cell: SearchResultSubTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else { return UITableViewCell() }
            
            cell.configureSearchResultSubTitleViewCell(args: track)
            
            return cell
        case .artist(artist: let artist):
            guard let cell: DefaultSearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: DefaultSearchResultTableViewCell.identifier, for: indexPath) as? DefaultSearchResultTableViewCell else { return UITableViewCell() }
            
            cell.configureDefaultSearchResultTableViewCell(args: artist)
            
            return cell
        case .album(album: let album):
            guard let cell: SearchResultSubTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else { return UITableViewCell() }
            
            cell.configureSearchResultSubTitleViewCell(args: album)
            
            return cell
        case .playlist(playlist: let playlist):
            guard let cell: SearchResultSubTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else { return UITableViewCell() }
            
            cell.configureSearchResultSubTitleViewCell(args: playlist)
            
            return cell
        case .show(show: let show):
            guard let cell: SearchResultSubTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubTitleTableViewCell.identifier, for: indexPath) as? SearchResultSubTitleTableViewCell else { return UITableViewCell() }
            
            cell.configureSearchResultSubTitleViewCell(args: show)
            
            return cell
        case .audiobook(audiobook: let audiobook):
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = audiobook?.name
            
            return cell
        }
    }
    
    ///  Optional Methods.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section].sectionHeaderTitle
    }
    
    // MARK: - UITableViewDelegate Method
    ///  Optional Method.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let searchResult: SearchResult = sections[indexPath.section].results[indexPath.row]
        
        delegate?.didTapResult(args: searchResult)
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct SearchResultsViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        SearchResultsViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct SearchResultsViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
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
