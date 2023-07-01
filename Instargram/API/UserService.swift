//
//  UserService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/01.
//

import Foundation
import Firebase

struct UserService {
    static func fetchUser(completion: @escaping(User)->Void) {
        // FireStore에 저장돼있는 유저 정보 가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            completion(User(dictionary: dictionary))
        }
    }
}
