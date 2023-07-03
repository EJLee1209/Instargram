//
//  ProfileCellViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import Foundation

struct ProfileCellViewModel {
    let post: Post
    
    var postImageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    init(post: Post) {
        self.post = post
    }
}
