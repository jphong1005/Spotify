//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by 홍진표 on 10/13/23.
//

import Foundation
import UIKit
import Then

protocol PlayerControlsViewDelegate: AnyObject {
    
    // MARK: - Function Prototypes
    func playerControlsViewDidTapPause(args playersControlsView: PlayerControlsView) -> Void
    func playerControlsViewDidTapBackward(args playersControlsView: PlayerControlsView) -> Void
    func playerControlsViewDidTapForward(args playersControlsView: PlayerControlsView) -> Void
}

class PlayerControlsView: UIView {
    
    // MARK: - Stored-prop
    weak var delegate: PlayerControlsViewDelegate?  //  Dependency Injection
    
    // MARK: - UI Components
    private let nameLabel: UILabel = UILabel().then {
        $0.text = "NAME LABEL"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    private let subTitleLabel: UILabel = UILabel().then {
        $0.text = "SUBTITLE LABEL"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .secondaryLabel
    }
    
    private let volumeSlider: UISlider = UISlider().then {
        $0.value = 0.5
    }
    
    private let backButton: UIButton = UIButton().then {
        $0.tintColor = .label
        $0.setImage(UIImage(systemName: "backward.end",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular)),
                    for: .normal)
        $0.addTarget(self, action: #selector(didTapBackward(_:)), for: .touchUpInside)
    }
    
    private let forwardButton: UIButton = UIButton().then {
        $0.tintColor = .label
        $0.setImage(UIImage(systemName: "forward.end",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular)),
                    for: .normal)
        $0.addTarget(self, action: #selector(didTapForward(_:)), for: .touchUpInside)
    }
    
    private let pauseButton: UIButton = UIButton().then {
        $0.tintColor = .label
        $0.setImage(UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,
                                                                           weight: .regular)),
                    for: .normal)
        $0.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
    }
    
    private let shuffleButton: UIButton = UIButton().then {
        $0.tintColor = .label
        $0.setImage(UIImage(systemName: "shuffle",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20,
                                                                           weight: .regular)),
                    for: .normal)
    }
    
    private let repeatButton: UIButton = UIButton().then {
        $0.tintColor = .label
        $0.setImage(UIImage(systemName: "repeat",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20,
                                                                           weight: .regular)),
                    for: .normal)
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(nameLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(volumeSlider)
        self.addSubview(backButton)
        self.addSubview(forwardButton)
        self.addSubview(pauseButton)
        self.addSubview(shuffleButton)
        self.addSubview(repeatButton)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frameBasedLayout()
    }
    
    private func frameBasedLayout() -> Void {
        
        nameLabel.frame = CGRect(x: 0,
                                 y: 0,
                                 width: width,
                                 height: 50)
        
        subTitleLabel.frame = CGRect(x: 0, 
                                     y: nameLabel.bottom + 10, 
                                     width: width,
                                     height: nameLabel.height)
        
        volumeSlider.frame = CGRect(x: 10, 
                                    y: subTitleLabel.bottom + 20,
                                    width: width - 20,
                                    height: 45)
        
        let buttonSize: CGFloat = 50.0
        
        backButton.frame = CGRect(x: (pauseButton.left - buttonSize) - 25,
                                  y: pauseButton.top,
                                  width: buttonSize,
                                  height: buttonSize)
        
        forwardButton.frame = CGRect(x: pauseButton.right + 25,
                                     y: pauseButton.top,
                                     width: buttonSize,
                                     height: buttonSize)
        
        pauseButton.frame = CGRect(x: (width - buttonSize) / 2, 
                                   y: volumeSlider.bottom + 30,
                                   width: buttonSize,
                                   height: buttonSize)
        
        shuffleButton.frame = CGRect(x: (backButton.left - buttonSize) - 25,
                                  y: pauseButton.top,
                                  width: buttonSize,
                                  height: buttonSize)
        
        repeatButton.frame = CGRect(x: forwardButton.right + 25,
                                  y: pauseButton.top,
                                  width: buttonSize,
                                  height: buttonSize)
    }
    
    // MARK: - Event Handler Methods
    @objc private func didTapBackward(_ sender: UIButton) -> Void {
        
        delegate?.playerControlsViewDidTapBackward(args: self)
    }
    
    @objc private func didTapPause(_ sender: UIButton) -> Void {
        
        delegate?.playerControlsViewDidTapPause(args: self)
    }
    
    @objc private func didTapForward(_ sender: UIButton) -> Void {
        
        delegate?.playerControlsViewDidTapForward(args: self)
    }
}
