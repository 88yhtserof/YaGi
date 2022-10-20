//
//  ContentDetailViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var contentTitle: UILabel = {
        var label = UILabel()
        
        label.text = "대신 꿈 꾸어 드립니다."
        label.font = .maruburi(ofSize: 25, weight: .bold)
        label.textColor = .yagiGrayDeep
        
        return label
    }()
    
    private lazy var menuBarItem: UIBarButtonItem = {
        var item = UIBarButtonItem()
        let action = UIAction { _ in
            print("Present Menu Bottom Sheet")
        }
        
        item.primaryAction = action
        item.image = UIImage(systemName: "menucard")
        
        return item
    }()
    
    private lazy var bookmarkBarItem: UIBarButtonItem = {
        var item = UIBarButtonItem()
        let action = UIAction { _ in
            print("Bookmark Content")
        }
        
        item.primaryAction = action
        item.image = UIImage(systemName: "bookmark.fill")
        
        return item
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
}

//MARK: - Configure
private extension ContentDetailViewController {
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItems = [menuBarItem, bookmarkBarItem]
    }
    
    func configureView() {
        self.view.backgroundColor = .yagiWhite
        
        [contentTitle].forEach { self.view.addSubview($0) }
        
        contentTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(130)
            make.leading.equalToSuperview().inset(30)
            make.width.equalTo(300)
        }
    }
}
