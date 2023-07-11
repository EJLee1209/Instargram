//
//  ChatRoom.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import Firebase

struct ChatRoom {
    let id: String
    let lastMessage: String
    let timestamp: Timestamp
    let users: [String]
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.lastMessage = dictionary["lastMessage"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.users = dictionary["users"] as? [String] ?? []
    }
}
