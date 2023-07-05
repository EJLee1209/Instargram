//
//  PostViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import Foundation

struct PostViewModel {
    var post: Post
    
    var ownerUsername: String { return post.ownerUsername }
    
    var ownerProfileImage: URL? { return URL(string: post.ownerImageUrl) }
    
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    
    var caption: String { return post.caption }
    
    var like: String {
        return post.likes == 1 ? "\(post.likes) like" : "\(post.likes) likes"
    }
    
    init(post: Post) {
        self.post = post
    }
    
    
}
