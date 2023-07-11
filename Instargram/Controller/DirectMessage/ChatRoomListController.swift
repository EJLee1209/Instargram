//
//  DirectMessageController.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import UIKit

private let reuseIdentifier = "directMessageCell"

class ChatRoomListController: UITableViewController {
    
    //MARK: - Properties
    var chatRooms: [ChatRoom] = []
        
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        fetchMessageList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MessagingService.removeChatRoomsListener()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        title = "Messages"
        tableView.register(ChatRoomCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(handleNewMessage)
        )
    }
    
    //MARK: - API
    
    func fetchMessageList() {
        MessagingService.fetchChatRoomsListener { [weak self] rooms in
            self?.chatRooms = rooms
            print("DEBUG: \(rooms)")
            self?.tableView.reloadData()
        }
        
    }

    
    //MARK: - Actions
    
    @objc func handleNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        present(controller, animated: true)
    }
    
    
}

//MARK: - UITableViewDataSource

extension ChatRoomListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatRoomCell
        cell.viewModel = ChatRoomViewModel(chatRoom: chatRooms[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ChatRoomListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let mainTab = tabBarController as? MainTabController else { return }
        guard let user = mainTab.user else { return }
        guard let receiverUid = chatRooms[indexPath.row].users.filter { $0 != user.uid }.first else { return }
        
        showLoader(true)
        UserService.fetchUser(withUid: receiverUid) { [weak self] receiver in
            self?.showLoader(false)
            let controller = MessagingController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.receiver = receiver
            controller.roomId = self?.chatRooms[indexPath.row].id
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - NewMessageControllerDelegate

extension ChatRoomListController: NewMessageControllerDelegate {
    func newMessage(_ viewController: NewMessageController, wantsToNewChatRoomWith user: User) {
        dismiss(animated: true)
        let controller = MessagingController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.receiver = user
        
        var myRoom : ChatRoom?
        chatRooms.forEach { room in
            if room.users.contains(user.uid) {
                myRoom = room
            }
        }
        
        if let room = myRoom {
            controller.roomId = room.id
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
