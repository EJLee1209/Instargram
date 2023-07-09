//
//  NotificationViewModel.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/08.
//

import UIKit

class NotificationViewModel {
    var notification: Notification {
        didSet {
            notificationObserver()
        }
    }
    
    var notificationObserver : () -> Void = {}
    
    init(notification: Notification) {
        self.notification = notification
        
        if notification.type == .follow {
            UserService.checkIfUserIsFollowed(uid: notification.uid) { [weak self] isFollowed in
                self?.notification.isFollowed = isFollowed
            }
        }
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
    
    var shouldHidePostImage: Bool {
        return notification.type == .follow
    }
    
    var buttonTitle: String {
        return notification.isFollowed ? "UnFollow" : "Follow"
    }
    
    var buttonBackgroundColor: UIColor {
        return notification.isFollowed ? .systemOrange : .systemBlue
    }
    
    
}
