//
//  NotificationService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/08.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications")
            .document()
        
        var data: [String: Any] = [
            "id": docRef.documentID,
            "timestamp": Timestamp(date: Date()),
            "uid": currentUid,
            "type": type.rawValue,
        ]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotification() {
        
    }
}
