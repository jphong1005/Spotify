//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    // MARK: - UI Component
    private let signIn: UIButton = {
        
        let button: UIButton = UIButton()
        
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSignIn(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemGreen
        
        self.title = "Spotify"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        self.view.addSubview(signIn)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyConstraints()
    }
    
    private func applyConstraints() -> Void {
        
        signIn.snp.makeConstraints { make in
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Event Handler
    @objc func didTapSignIn(_ sender: UIButton) -> Void {
        
        let authVC: AuthViewController = AuthViewController()
        
        authVC.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        self.navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleSignIn(success: Bool) -> Void {
        
        //  Log user in or yell at them for error.
        guard (success) else {
            let alert: UIAlertController = UIAlertController(title: "ALERT!",
                                                             message: "Something went wrong when sign in.",
                                                             preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let tabBarVC: TabBarViewController = TabBarViewController()
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
}

// MARK: - Live Preview
#if DEBUG
import SwiftUI

struct WelcomeViewControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - UIViewControllerRepresentable - Methods
    @available(iOS 15.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        
        WelcomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct WelcomeViewControllerRepresentable_PreviewProvider: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            WelcomeViewControllerRepresentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
