//
//  ContentDetailViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        scroll.delegate = self
        
        return scroll
    }()
    
    private lazy var contentTitle: UILabel = {
        var label = UILabel()
        
        label.text = "대신 꿈 꾸어 드립니다."
        label.font = .maruburi(ofSize: 25, weight: .bold)
        label.textColor = .yagiGrayDeep
        
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .yagiWhihtDeep
        
        return view
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
        
        [scrollView].forEach { self.view.addSubview($0) }
        [contentTitle, colorView].forEach { scrollView.addSubview($0) }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(30)
            make.width.equalTo(300)
        }
        
        colorView.snp.makeConstraints { make in
            make.top.equalTo(contentTitle.snp.bottom).offset(40)
            make.leading.trailing.bottom.equalToSuperview().inset(30)
            make.height.equalTo(3000)
            make.width.equalTo(100)
        }
    }
}

extension ContentDetailViewController: UIScrollViewDelegate {
    
}
