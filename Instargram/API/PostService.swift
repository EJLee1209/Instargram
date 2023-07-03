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
                "likes": 0,
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
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                let posts = documents.map { Post(postId: $0.documentID, dictionary: $0.data()) }
                completion(posts)
            }
    }
}
