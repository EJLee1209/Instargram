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
    
    private let refresher = UIRefreshControl()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotification { [weak self] notifications in
            self?.notifications = notifications
            self?.tableView.reloadData()
            print("DEBUG: 새로운 알림 도착")
        }
    }
    
    //MARK: - Actions
    @objc func handleRefresh() {
        fetchNotifications()
        refresher.endRefreshing()
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
        guard let viewModel = cell.viewModel else { return }
        cell.followButton.isEnabled = false
        cell.followButton.backgroundColor = .lightGray
        UserService.follow(uid: uid) { error in
            cell.followButton.isEnabled = true
            cell.followButton.backgroundColor = viewModel.buttonBackgroundColor
            if let error = error {
                print("DEBUG: 유저 팔로우 에러 발생 \(error.localizedDescription)")
                return
            }
            viewModel.notification.isFollowed.toggle()
        }
        
    }
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        guard let viewModel = cell.viewModel else { return }
        cell.followButton.isEnabled = false
        cell.followButton.backgroundColor = .lightGray
        UserService.unfollow(uid: uid) { error in
            cell.followButton.isEnabled = true
            cell.followButton.backgroundColor = viewModel.buttonBackgroundColor
            if let error = error {
                print("DEBUG: 유저 언팔로우 에러 발생 \(error.localizedDescription)")
                return
            }
        }
        viewModel.notification.isFollowed.toggle()
    }
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        showLoader(true)
        PostService.fetchPost(withPostId: postId) { [weak self] post in
            self?.showLoader(false)
            let controller = FeedController(mode: .notification)
            controller.post = post
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
