//
//  Comment.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/04.
//

import Firebase

struct Comment {
    let uid: String
    let username: String
    let profileImageUrl: String
    let commentText: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.commentText = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
