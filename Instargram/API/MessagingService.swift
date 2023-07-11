//
//  MessagingService.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import Firebase

struct MessagingService {
    
    private static var messagesListenerRegistration: ListenerRegistration?
    private static var chatRoomsListenerRegistration: ListenerRegistration?
    
    // 채팅방 가져오기
    static func fetchChatRoomsListener(completion: @escaping ([ChatRoom]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        chatRoomsListenerRegistration = COLLECTION_MESSAGES
            .order(by: "timestamp", descending: true)
            .whereField("users", arrayContains: uid)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                let rooms = documents.map { ChatRoom(dictionary: $0.data()) }
                
                completion(rooms)
            }
    }
    // 채팅방 생성
    static func createChatRoom(receiver uid: String, completion: @escaping (String) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let docRef = COLLECTION_MESSAGES.document()
        let docId = docRef.documentID
        
        let data: [String: Any] = [
            "id": docId,
            "lastMessage": "",
            "timestamp": Timestamp(date: Date()),
            "users": [currentUid, uid]
        ]
        
        docRef.setData(data) { _ in
            completion(docId)
        }
    }
    
    // 메세지 전송
    static func sendMessage(
        forRoom id: String,
        messageText: String,
        completion: @escaping (FirestoreCompletion)
    ) {
        guard let senderUid = Auth.auth().currentUser?.uid else { return }
        
        let docRef = COLLECTION_MESSAGES
            .document(id)
            .collection("message-store")
            .document()
        
        let docId = docRef.documentID
        let data: [String: Any] = [
            "id": docId,
            "messageText": messageText,
            "senderUid": senderUid,
            "timestamp": Timestamp(date: Date())
        ]
        
        docRef.setData(data) { _ in
            COLLECTION_MESSAGES
                .document(id)
                .updateData([
                    "lastMessage": messageText,
                    "timestamp": Timestamp(date: Date())
                ])
        }
    }
    
    // 메세지 가져오기
    static func fetchMessagesListener(
        forRoom id: String,
        completion: @escaping ([Message]) -> Void
    ) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        messagesListenerRegistration = COLLECTION_MESSAGES
            .document(id)
            .collection("message-store")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                let messages = documents.map{ Message(dictionary: $0.data(), currentUid: currentUid) }
                completion(messages)
            }
    }

    static func removeMessagesListener() {
        messagesListenerRegistration?.remove()
    }
    
    static func removeChatRoomsListener() {
        chatRoomsListenerRegistration?.remove()
    }
}
