//
//  DirectMessageViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import Foundation
import Firebase

class ChatRoomViewModel {
    var chatRoom: ChatRoom
    var receiver: User? {
        didSet {
            receiverObserver()
        }
    }
    
    var receiverObserver : () -> Void = {}
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let receiverUid = chatRoom.users.filter({ $0 != currentUid }).first else { return }
        UserService.fetchUser(withUid: receiverUid) { user in
            self.receiver = user
        }
    }
    
    var lastMessage: String {
        return chatRoom.lastMessage
    }
    
    var receiverProfileImageURL: URL? {
        guard let receiver = receiver else { return nil }
        return URL(string: receiver.profileImageUrl)
    }
    
    var receiverFullname: String? {
        return receiver?.fullname
    }
}
