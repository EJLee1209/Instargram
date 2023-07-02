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
    // 현재 로그인한 유저 데이터 가져오기
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
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
}
