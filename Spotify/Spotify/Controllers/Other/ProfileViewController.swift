//
//  ProfileViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class ProfileViewController: UIViewController {
    
    // MARK: - Stored-Props
    private let usersViewModel: UsersViewModel = UsersViewModel()
    private var models: [String] = [String]()
    private var bag: DisposeBag = DisposeBag()
    
    // MARK: - UI Component
    private let tableView: UITableView = {
        
        let tableView: UITableView = UITableView()
        
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        title = "Profile"
        navigationItem.largeTitleDisplayMode = .never
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        view.addSubview(self.tableView)
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = view.bounds
    }
    
    private func bind() -> Void {
        
        usersViewModel.userProfile
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .bind { [weak self] profile in
                self?.updateUI(with: profile)
                self?.tableView.reloadData()
            }.disposed(by: self.bag)
    }
    
    private func updateUI(with model: User) -> Void {
        
        self.tableView.isHidden = false
        
        //  Configure table models.
        models.append("Name: \(model.display_name)")
        models.append("E-mail: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        
        configureTableViewHeader(with: model.images)
    }
    
    private func failedToGetProfile() -> Void {
        
        let label: UILabel = UILabel(frame: .zero)
        
        label.text = "Failed to load your profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        
        view.addSubview(label)
        
        label.center = view.center
    }
    
    private func configureTableViewHeader(with images: [CommonGround.`Image`]) -> Void {
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width) / 1.5))
        let imageSize: CGFloat = (headerView.height) / 2
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        if (images.isEmpty == true) {   //  nil인 경우
            imageView.image = UIImage(systemName: "person.circle.fill")
            imageView.backgroundColor = .systemBackground
        } else {    //  not nil인 경우
            guard let strURL: String = images.first?.url, let url: URL = URL(string: strURL) else { return }
            imageView.sd_setImage(with: url)
        }
        
        headerView.addSubview(imageView)
        
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = (imageSize) / 2
        
        self.tableView.tableHeaderView = headerView
    }
}

// MARK: - Extension ViewController
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    ///  Required Methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            content.text = models[indexPath.row]
            cell.contentConfiguration = content
            cell.selectionStyle = .none
        } else {
            cell.textLabel?.text = models[indexPath.row]
            cell.selectionStyle = .none
        }
        
        return cell
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct ProfileViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        ProfileViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ProfileViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            WelcomeViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
