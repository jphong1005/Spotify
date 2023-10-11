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
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let searchResult: SearchResult = sections[indexPath.section].results[indexPath.row]
        
        switch searchResult {
        case .track(let track):
            cell.textLabel?.text = track?.name
            break;
        case .artist(artist: let artist):
            cell.textLabel?.text = artist?.name
            break;
        case .album(album: let album):
            cell.textLabel?.text = album?.name
            break;
        case .playlist(playlist: let playlist):
            cell.textLabel?.text = playlist?.name
            break;
        case .show(show: let show):
            cell.textLabel?.text = show?.name
            break;
        case .audiobook(audiobook: let audiobook):
            cell.textLabel?.text = audiobook?.name
            break;
        }
        
        return cell
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
