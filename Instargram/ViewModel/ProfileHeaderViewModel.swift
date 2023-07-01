//
//  ProfileHeaderViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/01.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
    }
    
    
}
