//
//  PlayerViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import Then

class PlayerViewController: UIViewController {

    // MARK: - UI Components
    private let playerImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemBlue
    }
    
    private let playerControlsView: PlayerControlsView = PlayerControlsView()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigurePlayerViewController()
        
        playerControlsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        frameBasedLayout()
    }
    
    private func defaultConfigurePlayerViewController() -> Void {
        
        view.backgroundColor = .systemBackground
        
        /// Configure Navigation Bar Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction(_:)))
        
        view.addSubview(playerImageView)
        view.addSubview(playerControlsView)
    }
    
    private func frameBasedLayout() -> Void {
        
        playerImageView.frame = CGRect(x: 0,
                                       y: view.safeAreaInsets.top,
                                       width: view.width,
                                       height: view.width)
        
        playerControlsView.frame = CGRect(x: 10,
                                          y: playerImageView.bottom + 10,
                                          width: view.width - 20,
                                          height: (view.height - playerImageView.height) - (view.safeAreaInsets.top - view.safeAreaInsets.bottom) - 15)
    }
    
    // MARK: - Event Handler Methods
    @objc private func didTapClose(_ sender: UIBarButtonItem) -> Void {
        
        dismiss(animated: true)
    }
    
    @objc private func didTapAction(_ sender: UIBarButtonItem) -> Void {
        
    }
}

// MARK: - Extension ViewController
extension PlayerViewController: PlayerControlsViewDelegate {
    
    // MARK: - PlayerControlsViewDelegate Methods Implementation
    func playerControlsViewDidTapPause(args playersControlsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDidTapBackward(args playersControlsView: PlayerControlsView) {
        
    }
    
    func playerControlsViewDidTapForward(args playersControlsView: PlayerControlsView) {
        
    }
}
