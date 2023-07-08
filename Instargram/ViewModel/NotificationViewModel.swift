//
//  NotificationViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/08.
//

import UIKit

struct NotificationViewModel {
    let notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: notification.userProfileImageUrl)
    }
    
    var notificationMessage: NSAttributedString {
        let attrText = NSMutableAttributedString(
            string: notification.username,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]
        )
        attrText.append(NSAttributedString(
            string: notification.type.notificationMessage,
            attributes: [.font: UIFont.systemFont(ofSize: 12)]
        ))
        attrText.append(NSAttributedString(
            string: "  2m",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.lightGray
            ]
        ))
        
        return attrText
    }
    
}
