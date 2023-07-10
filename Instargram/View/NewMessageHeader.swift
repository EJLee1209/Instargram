//
//  NewMessageHeader.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import UIKit

protocol NewMessageHeaderDelegate: AnyObject {
    func header(_ header: NewMessageHeader, textDidChanged searchText: String)
}

class NewMessageHeader: UIView {
    
    //MARK: - Properties
    
    weak var delegate: NewMessageHeaderDelegate?
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "New Message"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        return searchBar
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.anchor(top: topAnchor, paddingTop: 15)
        
        addSubview(searchBar)
        searchBar.anchor(
            top: titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 12,
            paddingLeft: 10,
            paddingRight: 10
        )
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UISearchBarDelegate

extension NewMessageHeader: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.header(self, textDidChanged: searchText)
    }
}
