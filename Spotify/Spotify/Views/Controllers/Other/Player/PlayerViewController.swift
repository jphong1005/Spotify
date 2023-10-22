//
//  PlayerViewController.swift
//  Spotify
//
//  Created by 홍진표 on 2023/08/31.
//

import UIKit
import Then
import SDWebImage
import AVFoundation

protocol PlayerViewControllerDelegate: AnyObject {
    
    // MARK: - Function Prototyps
    func didTapPause() -> Void
    func didTapBackward() -> Void
    func didTapForward() -> Void
    func didSlideSlider(args value: Float) -> Void
}

class PlayerViewController: UIViewController {
    
    // MARK: - Stored-Props
    weak var dataSource: PlayerViewDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - UI Components
    private let playerImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    private let playerControlsView: PlayerControlsView = PlayerControlsView()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultConfigurePlayerViewController()
        
        playerControlsView.delegate = self
        
        configurePlayerViewController()
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
    
    private func configurePlayerViewController() -> Void {
            
        playerImageView.sd_setImage(with: dataSource?.currentTrackObjectURL)
        playerControlsView.configurePlayerControlsView(firstArgs: dataSource?.currentTrackObjectName ?? "", SecondArgs: dataSource?.currentTrackObjectSubTitle ?? "")
    }
    
    public func refreshUI() -> Void {
        
        configurePlayerViewController()
    }
    
    // MARK: - Event Handler Methods
    @objc private func didTapClose(_ sender: UIBarButtonItem) -> Void {
        
        dismiss(animated: true)
    }
    
    @objc private func didTapAction(_ sender: UIBarButtonItem) -> Void {}
}

// MARK: - Extension ViewController
extension PlayerViewController: PlayerControlsViewDelegate {
    
    // MARK: - PlayerControlsViewDelegate Methods Implementation
    func playerControlsViewDidTapPause(args playersControlsView: PlayerControlsView) {
        
        delegate?.didTapPause()
    }
    
    func playerControlsViewDidTapBackward(args playersControlsView: PlayerControlsView) {
        
        delegate?.didTapBackward()
    }
    
    func playerControlsViewDidTapForward(args playersControlsView: PlayerControlsView) {
        
        delegate?.didTapForward()
    }
    
    func playerControlsView(firstArgs playerControlsView: PlayerControlsView, secondArgs didSlideSliderValue: Float) {
        
        delegate?.didSlideSlider(args: didSlideSliderValue)
    }
}
