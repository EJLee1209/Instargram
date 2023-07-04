//
//  Comment.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/04.
//

import Foundation
import Firebase

struct Comment {
    let ownerImageUrl: String
    let ownername: String
    let comment: String
    let timestamp: Timestamp
    
    init(dictionary: [String:Any]) {
        self.ownerImageUrl = dictionary["ownerImageUrl"] as! String
        self.ownername = dictionary["ownername"] as! String
        self.comment = dictionary["comment"] as! String
        self.timestamp = dictionary["timestamp"] as! Timestamp
    }
}
