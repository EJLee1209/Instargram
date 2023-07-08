//
//  NotificationService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/08.
//

import Firebase

struct NotificationService {
    
    private static var listenerRegistration: ListenerRegistration?
    
    static func uploadNotification(
        toUid uid: String, // 받는 사람의 uid
        fromUser user: User, // 보내는 사람
        type: NotificationType,
        post: Post? = nil
    ){
        guard uid != user.uid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications")
            .document()
        
        var data: [String: Any] = [
            "id": docRef.documentID,
            "timestamp": Timestamp(date: Date()),
            "uid": user.uid,
            "type": type.rawValue,
            "userProfileImageUrl": user.profileImageUrl,
            "username": user.username
        ]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotification(completion: @escaping ([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        listenerRegistration = COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let notifications = documents.map { Notification(dictionary: $0.data()) }
                
                completion(notifications)
            }
    }
    
    static func removeRegistration() {
        listenerRegistration?.remove()
    }
}
