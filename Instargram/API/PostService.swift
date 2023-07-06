//
//  PostService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import UIKit
import Firebase

struct PostService {
    static func uploadPost(
        caption: String,
        image: UIImage,
        ownerUsername: String,
        ownerImageUrl: String,
        completion: @escaping FirestoreCompletion
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String : Any] = [
                "ownerUid": uid,
                "caption" : caption,
                "imageUrl": imageUrl,
                "ownerUsername": ownerUsername,
                "ownerImageUrl": ownerImageUrl,
                "likedUsers": [String](),
                "timestamp": Timestamp(date: Date()),
            ]
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping ([Post]) -> Void ) {
        COLLECTION_POSTS
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                let posts = documents.map{ Post(postId: $0.documentID, dictionary: $0.data()) }
                completion(posts)
            }
    }
    
    static func fetchPosts(forUser uid: String?, completion: @escaping([Post]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid ?? currentUid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                let posts = documents.map { Post(postId: $0.documentID, dictionary: $0.data()) }
                completion(posts)
            }
    }
    
    
    static func likeOrUnlikePost(post: Post, completion: @escaping ([String], Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = COLLECTION_POSTS.document(post.postId)
        var likedUsers: [String] = []
        
        ref.firestore.runTransaction({ transaction, errorPointer in
            let postDocument: DocumentSnapshot
            do {
                postDocument = try transaction.getDocument(ref)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let data = postDocument.data()?["likedUsers"] as? [String] else { return nil }
            likedUsers = data
            
            if likedUsers.contains(uid) {
                likedUsers.removeAll { $0 == uid }
            } else {
                likedUsers.append(uid)
            }
            transaction.updateData(["likedUsers": likedUsers], forDocument: ref)
            
            return nil
        }, completion: { _, error in
            completion(likedUsers, error)
        })

        
        
        
    }
}
