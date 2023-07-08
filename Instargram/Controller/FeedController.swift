//
//  Feed.swift
//  Instargram
//
//  Created by 이은재 on 2023/06/29.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

enum FeedMode {
    case normal
    case profile
}

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    var posts: [Post] = []
    let mode : FeedMode
    
    init(mode: FeedMode) {
        self.mode = mode
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        fetchPosts()
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }catch {
            print("DEBUG: Failed to sign out")
        }
    }
    //MARK: - API
    
    func fetchPosts() {
        if mode == .normal {
            PostService.fetchPosts { [weak self] posts in
                self?.posts = posts
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }
        } else {
            PostService.fetchPosts(forUser: nil) { [weak self] posts in
                self?.posts = posts
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Feed"
        if mode == .normal {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Logout",
                style: .done,
                target: self,
                action: #selector(handleLogout)
            )
        }
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

//MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    // 컬렉션 뷰 셀의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8 // 8은 패딩값, 40은 프로필 이미지뷰 지름
        height += 110 // 좋아요 버튼, 나머지 라벨 높이
        return CGSize(width: width, height: height)
    }
}

//MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        // 하트 버튼 눌렀을 때
        cell.likeButton.isEnabled.toggle()
        PostService.likeOrUnlikePost(post: post) { likedUsers, error in
            cell.likeButton.isEnabled.toggle()
            if let error = error {
                print("DEBUG: likeOrUnlikePost Error \(error.localizedDescription)")
                return
            }
            cell.viewModel?.post.likedUsers = likedUsers
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { [weak self] user in
            let controller = ProfileController(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
