//
//  CommentCell.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import UIKit
import SDWebImage

class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: CommentViewModel? {
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
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.centerY(
            inView: profileImageView,
            leftAnchor: profileImageView.rightAnchor,
            paddingLeft: 8
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        profileImageView.sd_setImage(with: viewModel?.ownerImage)
        let attributedString = NSMutableAttributedString(
            string: "\(viewModel?.ownername ?? "")  ",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 14)
            ]
        )
        attributedString.append(
            NSAttributedString(
                string: "\(viewModel?.text ?? "")",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14)
                ]
            )
        )
        commentLabel.attributedText = attributedString
    }
}
