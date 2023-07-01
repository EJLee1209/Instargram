//
//  MainTabController.swift
//  Instargram
//
//  Created by 이은재 on 2023/06/29.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        checkIfUserIsLoggedIn()
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    
    //MARK: - Helpers
    func configureViewControllers() {
        // 탭바 뷰컨트롤러 설정
        let layout = UICollectionViewFlowLayout() // 컬렉션뷰를 초기화하기 위해 UICollectionViewFlowLayout() 인스턴스 생성 후 전달
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        let profileLayout = UICollectionViewFlowLayout()
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController(collectionViewLayout: profileLayout))
        
        viewControllers = [feed, search, imageSelector, notification, profile]
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemBackground
    }
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        // 탭바의 뷰컨트롤러로 들어갈 UINavigationController를 생성 -> 탭바의 컨트롤러 각각은 UINavigationController임
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        // UINavigationBarAppearance를 설정해야 NavBar의 background를 지정할 수 있음
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor =  .systemBackground
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        return nav
    }
    
}


