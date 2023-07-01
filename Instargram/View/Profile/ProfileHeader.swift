//
//  ProfileHeader.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/01.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
