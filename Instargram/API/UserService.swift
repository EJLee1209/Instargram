//
//  UserService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/01.
//

import Foundation
import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    // 유저 데이터 가져오기
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            completion(User(dictionary: dictionary))
        }
    }
    // 모든 유저 데이터 가져오기
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.map { User(dictionary: $0.data()) }
            completion(users)
        }
    }
    
    // 팔로우
    static func follow(uid: String, completion: @escaping FirestoreCompletion) {
        /*
            팔로우를 하면 두 개의 Collection을 모두 업데이트 해줘야 함.
            Collection : followers, following
            followers는 현재 유저가 팔로우 하는 유저
            following은 현재 유저를 팔로우 하는 유저
         
            파라미터로 받은 uid는 팔로우를 할 유저의 uid
            */
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .setData([:]) { error in
                COLLECTION_FOLLOWERS
                    .document(uid)
                    .collection("user-followers")
                    .document(currentUid)
                    .setData(
                        [:],
                        completion: completion
                    )
            }
    }
    // 언팔로우
    static func unfollow(uid: String, completion: @escaping FirestoreCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .delete { error in
                COLLECTION_FOLLOWERS
                    .document(uid)
                    .collection("user-followers")
                    .document(currentUid)
                    .delete(completion: completion)
            }
    }
    
    // 팔로우 여부 확인
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .getDocument { snapshot, error in
                guard let isFollowed = snapshot?.exists else { return }
                completion(isFollowed)
            }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS
            .document(uid)
            .collection("user-followers")
            .getDocuments { snapshot, _ in
                let followers = snapshot?.documents.count ?? 0
                
                COLLECTION_FOLLOWING
                    .document(uid)
                    .collection("user-following")
                    .getDocuments { snapshot, _ in
                        let following = snapshot?.documents.count ?? 0
                        
                        COLLECTION_POSTS
                            .whereField("ownerUid", isEqualTo: uid)
                            .getDocuments(completion: { snapshot, _ in
                                let numberOfPost = snapshot?.documents.count ?? 0
                                let stats = UserStats(
                                    followers: followers,
                                    following: following,
                                    numberOfPost: numberOfPost
                                )
                                completion(stats)
                            })
                    }
            }
    }
    
    // 유저가 팔로우 중인 사람들의 uid 가져오기
    static func fetchFollowing(uid: String, completion: @escaping([String]) -> Void) {
        COLLECTION_FOLLOWING
            .document(uid)
            .collection("user-following")
            .getDocuments { snapshot, _ in
                guard let documents =  snapshot?.documents else {
                    completion([])
                    return
                }
                
                let following = documents.map{ $0.documentID }
                completion(following)
            }
    }
    
}
