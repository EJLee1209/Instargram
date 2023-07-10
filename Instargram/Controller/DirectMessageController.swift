//
//  DirectMessageController.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/10.
//

import UIKit

private let reuseIdentifier = "directMessageCell"

class DirectMessageController: UITableViewController {
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        title = "Messages"
        tableView.register(DirectMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(handleNewMessage)
        )
    }
    
    //MARK: - Actions
    
    @objc func handleNewMessage() {
        let controller = NewMessageController()
        present(controller, animated: true)
    }
    
    
}

//MARK: - UITableViewDataSource

extension DirectMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DirectMessageCell
        return cell
    }
}

//MARK: - UITableViewDelegate

extension DirectMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
