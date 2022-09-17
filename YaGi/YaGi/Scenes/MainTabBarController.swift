//
//  MainTabBarController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/09/09.
//

import SnapKit

import UIKit

final class MainTabBarController: UITabBarController {
    //MARK: - View
    private lazy var contentsViewController: UINavigationController = {
        let viewController = UINavigationController(rootViewController: ContentsViewController())
        
        let tabBarItem: UITabBarItem = {
            let item = UITabBarItem(
                title: "목차",
                image: UIImage(systemName: "book.closed"),
                selectedImage: UIImage(systemName: "book.fill")
            )
            item.tag = 0
            
            return item
        }()
        
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.viewControllers = [contentsViewController]
        self.tabBar.tintColor = .yagiGray
    }
}
