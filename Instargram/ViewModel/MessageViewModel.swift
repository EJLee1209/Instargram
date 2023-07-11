//
//  MessageViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/11.
//

import Foundation

class MessageViewModel {
    let message: Message
    var receiver: User?
    
    init(message: Message, receiver: User?) {
        self.message = message
        self.receiver = receiver
    }
    
    var messageText: String {
        return message.messageText
    }
    
    var profileImageURL: URL? {
        guard let receiver else { return nil }
        return URL(string: receiver.profileImageUrl)
    }
}
