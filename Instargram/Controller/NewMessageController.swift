//
//  NewMessageController.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import UIKit

private let reuseIdentifier = "UserCell"

class NewMessageController: UITableViewController {
    
    //MARK: - Properties
    
    var users : [User] = []
    var filteredUsers: [User] = [] // 검색어에 따라 유저 목록 필터링
    
    var searchMode = false
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchFriends()
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
        
    }
    
    //MARK: - API
    
    func fetchFriends() {
        showLoader(true)
        UserService.fetchFollowingUsers { [weak self] users in
            self?.users = users
            self?.tableView.reloadData()
            self?.showLoader(false)
        }
    }
}


//MARK: - TableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMode ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.viewModel = UserCellViewModel(user: searchMode ? filteredUsers[indexPath.row] : users[indexPath.row])
        return cell
    }
    // header 높이
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    // header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NewMessageHeader()
        header.delegate = self
        return header
    }
}

//MARK: - TableViewDelegate

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchMode {
            print("DEBUG: \(filteredUsers[indexPath.row].fullname)님과 새로운 채팅을 시작합니다")
        } else {
            print("DEBUG: \(users[indexPath.row].fullname)님과 새로운 채팅을 시작합니다")
        }
        
    }
}

//MARK: - NewMessageHeaderDelegate

extension NewMessageController: NewMessageHeaderDelegate {
    func header(_ header: NewMessageHeader, textDidChanged searchText: String) {
        searchMode = !searchText.isEmpty
        
        // 검색어로 유저 목록 필터링
        filteredUsers = users.filter {
            $0.username.contains(searchText) ||
            $0.fullname.contains(searchText)
        }
        tableView.reloadData()
    }
}
