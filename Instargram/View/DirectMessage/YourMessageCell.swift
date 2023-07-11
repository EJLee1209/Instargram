//
//  YourMessageCell.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/11.
//

import UIKit

class YourMessageCell : UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: MessageViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    
    let messageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "test test"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.backgroundColor = .white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.sizeToFit()
        return label
    }()
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        addSubview(messageLabel)
        messageLabel.anchor(left: profileImageView.rightAnchor, bottom: profileImageView.centerYAnchor, paddingLeft: 12, paddingBottom: -8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        messageLabel.text = viewModel?.messageText
        profileImageView.sd_setImage(with: viewModel?.profileImageURL)
    }
}
