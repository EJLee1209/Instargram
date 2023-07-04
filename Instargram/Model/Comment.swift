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
    
    init(dictinary: [String: Any]) {
        self.uid = dictinary["uid"] as? String ?? ""
        self.username = dictinary["username"] as? String ?? ""
        self.profileImageUrl = dictinary["profileImageUrl"] as? String ?? ""
        self.commentText = dictinary["comment"] as? String ?? ""
        self.timestamp = dictinary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
