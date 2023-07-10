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
        tableView.register(DirectMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
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
