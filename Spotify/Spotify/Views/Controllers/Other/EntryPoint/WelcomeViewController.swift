//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import SnapKit
import Then

class WelcomeViewController: UIViewController {
    
    // MARK: - UI Components
    private let signIn: UIButton = {
        
        let button: UIButton = UIButton()
        
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSignIn(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let overlayView: UIView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.5
    }
    
    private let logoImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let label: UILabel = UILabel().then {
        $0.text = "Listen Millions \n of Songs on \n the go."
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        title = "Spotify"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(overlayView)
        view.addSubview(signIn)
        view.addSubview(self.label)
        view.addSubview(logoImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.overlayView.frame = view.bounds
        applyConstraints()
    }
    
    private func applyConstraints() -> Void {
        
        signIn.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-100)
            make.width.height.equalTo(150)
        }

        label.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.height.equalTo(150)
        }

    }
    
    // MARK: - Event Handler Methods
    @objc func didTapSignIn(_ sender: UIButton) -> Void {
        
        let authVC: AuthViewController = AuthViewController()
        
        authVC.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleSignIn(success: Bool) -> Void {
        
        //  Log user in or yell at them for error.
        guard (success) else {
            let alert: UIAlertController = UIAlertController(
                title: "ALERT!",
                message: "Something went wrong when sign in.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel))
            self.present(alert, animated: true)
            return
        }
        
        let tabBarVC: TabBarViewController = TabBarViewController()
        
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true)
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
