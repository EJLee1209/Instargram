//
//  PostViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import Foundation
import Firebase

struct PostViewModel {
    var post: Post
    
    var ownerUsername: String { return post.ownerUsername }
    
    var ownerProfileImage: URL? { return URL(string: post.ownerImageUrl) }
    
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    
    var caption: String { return post.caption }
    
    var like: String {
        return post.likedUsers.count == 1 ? "\(post.likedUsers.count) like" : "\(post.likedUsers.count) likes"
    }
    
    var isLiked: Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        return post.likedUsers.contains(uid)
    }
    
    init(post: Post) {
        self.post = post
    }
    
    
}
