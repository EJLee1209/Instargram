//
//  NotificationController.swift
//  Instargram
//
//  Created by 이은재 on 2023/06/29.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    //MARK: - Properties
    
    var notifications: [Notification] = []
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationService.removeRegistration()
    }
    
    //MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotification { [weak self] notifications in
            self?.notifications = notifications
            self?.tableView.reloadData()
        }
    }
    
    func checkIfUserIsFollowed() {
        notifications.forEach { notifications in
            
        }
    }
}

//MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: - NotificationCellDelegate
extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        print("DEBUG: Follow here...")
        guard let viewModel = cell.viewModel else { return }
        viewModel.notification.isFollowed.toggle()
    }
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        print("DEBUG: Unfollow here...")
        guard let viewModel = cell.viewModel else { return }
        viewModel.notification.isFollowed.toggle()
    }
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        print("DEBUG: Show post here..")
        
    }
}
