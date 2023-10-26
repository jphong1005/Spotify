//
//  ActionLabelView.swift
//  Spotify
//
//  Created by 홍진표 on 10/23/23.
//

import UIKit
import Then

protocol ActionLabelViewDelegate: AnyObject {
    
    // MARK: - Fuction Prototype
    func actionLabelViewDidTapButton(actionView: ActionLabelView) -> Void
}

class ActionLabelView: UIView {
    
    // MARK: - UI Components
    private let label: UILabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .secondaryLabel
    }
    
    private let button: UIButton = UIButton().then {
        $0.setTitleColor(.link, for: .normal)
        $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - Stored-Prop
    weak var delegate: ActionLabelViewDelegate?
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        
        self.addSubview(label)
        self.addSubview(button)
        
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frameBasedLayout()
    }
    
    public func configureActionLabelView(first_args text: String, second_args actionTitle: String) -> Void {
        
        self.label.text = text
        self.button.setTitle(actionTitle, for: .normal)
    }
    
    private func frameBasedLayout() -> Void {
        
        self.button.frame = CGRect(x: 0,
                                   y: self.height - 50,
                                   width: self.width,
                                   height: 50)
        
        self.label.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.width,
                                  height: self.height - 60)
    }
    
    // MARK: - Event Handler Method
    @objc private func didTapButton(_ sender: UIButton) -> Void {
        
        delegate?.actionLabelViewDidTapButton(actionView: self)
    }
}
