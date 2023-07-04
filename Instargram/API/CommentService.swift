//
//  CommentService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/04.
//

import Firebase

struct CommentService {
    static func postComment(
        postId: String,
        ownerImageUrl: String,
        ownername: String,
        comment: String,
        completion: @escaping FirestoreCompletion
    ) {
        COLLECTION_POSTS
            .document(postId)
            .collection("comments")
            .addDocument(
                data: [
                    "ownerImageUrl": ownerImageUrl,
                    "ownername": ownername,
                    "comment" : comment,
                    "timestamp": Timestamp(date: Date())
                ],
                completion: completion
            )
    }
    
    static func fetchComments(
        postId: String,
        completion: @escaping ([Comment]) -> Void
    ) {
        COLLECTION_POSTS
            .document(postId)
            .collection("comments")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let comments = documents.map { Comment(dictionary: $0.data()) }
                
                completion(comments)
            }
    }
}
