//
//  MyMessageCell.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/11.
//

import UIKit

class MyMessageCell : UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: MessageViewModel? {
        didSet {
            configure()
        }
    }
    
    let messageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "test test"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9137254902, blue: 0.9490196078, alpha: 1)
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.sizeToFit()
        return label
    }()
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(messageLabel)
        messageLabel.anchor(
            top: topAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 5,
            paddingBottom: 5,
            paddingRight: 8
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        messageLabel.text = viewModel?.messageText
    }
}
