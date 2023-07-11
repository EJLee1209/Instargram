//
//  Message.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/11.
//

import Firebase

struct Message {
    let id: String
    let messageText: String
    let senderUid: String
    let timestamp: Timestamp
    
    let currentUid: String
    var isMyMessage: Bool {
        return senderUid == currentUid
    }
    
    init(dictionary: [String: Any], currentUid: String) {
        self.id = dictionary["id"] as? String ?? ""
        self.messageText = dictionary["messageText"] as? String ?? ""
        self.senderUid = dictionary["senderUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.currentUid = currentUid
    }
}
