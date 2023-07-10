//
//  DirectMessageCell.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import UIKit

class DirectMessageCell: UITableViewCell {
    
    //MARK: - Properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "이은재"
        return label
    }()
    
    private let recentMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "안녕하세요 테스트 메세지 입니다"
        return label
    }()
    
    private lazy var stackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [usernameLabel, recentMessageLabel])
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 64, width: 64)
        profileImageView.layer.cornerRadius = 32
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

