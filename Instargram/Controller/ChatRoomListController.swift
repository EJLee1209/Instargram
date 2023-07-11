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
        fetchMessageList()
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
        MessagingService.fetchChatRooms { [weak self] rooms in
            self?.chatRooms = rooms
            print("DEBUG: \(rooms)")
            self?.tableView.reloadData()
        }
        
    }

    
    //MARK: - Actions
    
    @objc func handleNewMessage() {
        let controller = NewMessageController()
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
        
    }
}
