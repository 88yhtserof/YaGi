//
//  BookshelfViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/20.
//

import UIKit

class BookshelfViewController: UIViewController {
    private lazy var settingBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        
        let action = UIAction {_ in
            let menuViewController = SettingViewController()
            self.navigationController?.pushViewController(menuViewController, animated: true)
        }
        
        item.primaryAction = action
        item.image = UIImage(systemName: "ellipsis")
        item.tintColor = .yagiGray
        
        return item
    }()
    
    private lazy var editBookcoverBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        
        let action = UIAction { _ in
            print("Present ImagePicker")
        }
        
        item.primaryAction = action
        item.image = UIImage(systemName: "photo.on.rectangle.angled")
        item.tintColor = .yagiGray
        
        return item
    }()
    
    private lazy var bookcoverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Yagi_bookshelf_480")
        imageView.layer.shadowColor = UIColor.yagiGrayLight.cgColor
        imageView.layer.shadowOffset = CGSize(width: -13, height: 20)
        imageView.layer.shadowOpacity = 0.2
        return imageView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "책 제목 Label"
        label.font = .maruburi(ofSize: 20, weight: .semiBold)
        label.textColor = .yagiGrayDeep
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var bookcoverDesignImageView: UIImageView = {
        let imageView = UIImageView()
        
        // TODO: - 이미지 위치 확인용이므로 수정 필요
        imageView.backgroundColor = .yagiGrayDeep
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
}

private extension BookshelfViewController {
    func configureNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .yagiGray
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem = editBookcoverBarItem
        self.navigationItem.rightBarButtonItem = settingBarItem
    }
    
    func configureView() {
        self.view.backgroundColor = .yagiWhite
        
        [
            bookcoverDesignImageView,
            bookTitleLabel
        ]
            .forEach{ bookcoverImageView.addSubview($0) }
        
        [
            bookcoverImageView
        ]
            .forEach{ view.addSubview($0) }
        
        bookcoverImageView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
        
        bookTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalToSuperview().inset(100)
        }
        
        bookcoverDesignImageView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(26)
            make.bottom.equalToSuperview().inset(3)
            make.top.equalTo(bookTitleLabel.snp.bottom)
            
        }
    }
}
