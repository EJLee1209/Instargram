//
//  PostViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import Foundation

struct PostViewModel {
    private let post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var caption: String {
        return post.caption
    }
    
    var like: String {
        return "\(post.likes) like"
    }
    
    
    
    init(post: Post) {
        self.post = post
    }
    
    
}
