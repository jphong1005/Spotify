//
//  ViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemBackground
        
        self.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationBarUI()
    }
    
    private func navigationBarUI() -> Void {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didTapSettings))
    }
    
    @objc func didTapSettings() -> Void {
        
        let settingsVC: SettingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct HomeViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - (Required) Methods
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
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
