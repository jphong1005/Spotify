//
//  TabBarViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        
        self.settingTabBarUI()
    }
    
    private func settingTabBarUI() -> Void {
        
        let homeVC: UINavigationController = UINavigationController(rootViewController: HomeViewController())
        let searchVC: UINavigationController = UINavigationController(rootViewController: SearchViewController())
        let libraryVC: UINavigationController = UINavigationController(rootViewController: LibraryViewController())
        
        homeVC.title = "Home"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        homeVC.navigationBar.tintColor = .label
        
        searchVC.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        searchVC.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        searchVC.navigationBar.tintColor = .label
        
        libraryVC.title = "Library"
        libraryVC.tabBarItem.image = UIImage(systemName: "square.on.square")
        libraryVC.tabBarItem.selectedImage = UIImage(systemName: "square.filled.on.square")
        libraryVC.navigationBar.tintColor = .label
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, searchVC, libraryVC], animated: false)
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct TabBarViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - (Required) Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        TabBarViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct TabBarViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            TabBarViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
