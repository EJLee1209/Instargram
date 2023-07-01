//
//  UserService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/01.
//

import Foundation
import Firebase

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        // 현재 로그인한 유저 데이터 가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            completion(User(dictionary: dictionary))
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        // 모든 유저 데이터 가져오기
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.map { User(dictionary: $0.data()) }
            completion(users)
        }
    }
}
