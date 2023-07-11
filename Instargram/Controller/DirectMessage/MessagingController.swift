//
//  MessagingController.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/11.
//

import UIKit

private let myCellIdentifier = "myMessageCell"
private let yourCellIdentifier = "yourMessageCell"

class MessagingController: UICollectionViewController {
    
    //MARK: - Properties
    
    var receiver: User? {
        didSet {
            configure()
        }
    }
    var roomId: String? {
        didSet {
            fetchMessages()
        }
    }
    
    var messages: [Message] = []
    
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.postButton.setTitle("Send", for: .normal)
        cv.commentTextView.placeholderText = "Message.."
        cv.delegate = self
        return cv
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MessagingService.removeMessagesListener()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
        
    //MARK: - Helpers
    func setupTableView() {
        collectionView.register(MyMessageCell.self, forCellWithReuseIdentifier: myCellIdentifier)
        collectionView.register(YourMessageCell.self, forCellWithReuseIdentifier: yourCellIdentifier)
        collectionView.keyboardDismissMode = .interactive
    }
    func configure() {
        title = receiver?.fullname
    }
    
    //MARK: - API
    
    func fetchMessages() {
        guard let roomId = roomId else { return }
        MessagingService.fetchMessagesListener(forRoom: roomId) { [weak self] messages in
            self?.messages = messages
            self?.collectionView.reloadData()
            self?.collectionView.scrollToItem(at: IndexPath(row: messages.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    
}

//MARK: - UICollectionViewDataSource
extension MessagingController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if messages[indexPath.row].isMyMessage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myCellIdentifier, for: indexPath) as! MyMessageCell
            cell.viewModel = MessageViewModel(message: messages[indexPath.row], receiver: nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: yourCellIdentifier, for: indexPath) as! YourMessageCell
            cell.viewModel = MessageViewModel(message: messages[indexPath.row], receiver: receiver)
            return cell
        }
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension MessagingController: UICollectionViewDelegateFlowLayout {
    // 연속적인 셀 사이의 간격 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    // cell의 크기 조정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellSize = NSString(string: messages[indexPath.row].messageText).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ],
            context: nil)
        
        if messages[indexPath.row].isMyMessage {
            return CGSize(width: view.frame.width, height: cellSize.height + 20)
        } else {
            return CGSize(width: view.frame.width, height: cellSize.height + 40)
        }

    }

}

extension MessagingController : CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        commentInputView.clearCommentTextView()
        guard let receiver = receiver else { return }
        
        guard let roomId = roomId else {
            MessagingService.createChatRoom(receiver: receiver.uid) { [weak self] id in
                self?.roomId = id
                
                MessagingService.sendMessage(forRoom: id, messageText: comment) { _ in }
            }
            return
        }
        
        MessagingService.sendMessage(forRoom: roomId, messageText: comment) { _ in }
    }
}

