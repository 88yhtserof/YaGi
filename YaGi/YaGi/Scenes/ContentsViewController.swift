//
//  ContentsViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/09/17.
//

import UIKit

class ContentsViewController: UIViewController {
    
    //MARK: - View
    private lazy var menuBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "ellipsis")
        item.tintColor = .yagiGray
        
        return item
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
}

//MARK: -  Configure
private extension ContentsViewController {
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
}
