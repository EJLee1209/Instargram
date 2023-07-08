//
//  CommentService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/04.
//

import Firebase

struct CommentService {
    static var commentListener: ListenerRegistration?
    
    static func uploadComment(
        comment: String,
        postID: String,
        user: User,
        completion: @escaping(FirestoreCompletion)
    ) {
        let data: [String: Any] = [
            "uid" : user.uid,
            "comment" : comment,
            "timestamp" : Timestamp(date: Date()),
            "username": user.username,
            "profileImageUrl" : user.profileImageUrl
        ]
        COLLECTION_POSTS.document(postID).collection("comments")
            .addDocument(data: data, completion: completion)
    }
    
    static func fetchComment(
        forPost postID: String,
        completion: @escaping ([Comment]) -> Void
    ) {
        var comments = [Comment]()
        commentListener = COLLECTION_POSTS
            .document(postID)
            .collection("comments")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let comments = documents.map { Comment(dictionary: $0.data()) }
                completion(comments)
            }
    }
    
    static func removeCommentListener() {
        commentListener?.remove()
    }
}
