//
//  CommentController.swift
//  Instargram
//
//  Created by 이은재 on 2023/07/03.
//

import UIKit

private let reuseIdentifier = "CommentCell"

class CommentController : UICollectionViewController {
    
    //MARK: - Properties
    
    var post: Post!
    var user: User!
    
    var comments: [Comment] = []
    
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }
    
    // inputAccessoryView : 키보드 위에 보여주고 싶은 View가 있을 때 사용
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - API
    
    func fetchComments() {
        CommentService.fetchComments(postId: post.postId) { [weak self] comments in
            self?.comments = comments
            self?.collectionView.reloadData()
            print("DEBUG: comments \(comments)")
        }
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = "Comment"
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
}

//MARK: - UICollectionViewDataSource
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

//MARK: - CommentInputAccesoryViewDelegate
extension CommentController: CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        inputView.clearCommentTextView()
        guard let post = post else { return }
        CommentService.postComment(
            postId: post.postId,
            ownerImageUrl: user.profileImageUrl,
            ownername: user.username,
            comment: comment) { [weak self] error in
                if let error = error {
                    print("DEBUG: Failed to upload comment with error \(error.localizedDescription)")
                    return
                }
                
                self?.fetchComments()
            }
    }
}
