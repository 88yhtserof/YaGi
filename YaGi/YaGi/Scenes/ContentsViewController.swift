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
    
    private lazy var titleButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        
        var attributedTitle = AttributedString("달러구트 꿈 백화점 1 해리를 찾아라")
        attributedTitle.font = .maruburi(ofSize: 25, weight: .bold)
        attributedTitle.foregroundColor = UIColor.yagiGrayDeep
        
        let paragraphTitle = NSMutableParagraphStyle()
        paragraphTitle.lineSpacing = 0.3 * (attributedTitle.font?.lineHeight ?? 1)
        paragraphTitle.lineBreakStrategy = .hangulWordPriority
        
        attributedTitle.paragraphStyle = paragraphTitle
        
        configuration.attributedTitle = attributedTitle
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 10
        configuration.imagePlacement = .trailing
        configuration.imageColorTransformer = .init({_ in return UIKit.UIColor.yagiGrayLight})
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 0, bottom: 50, trailing: 0)
        
        let action = UIAction { action  in
            //Present Write View
            print("Present Write View")
        }
        
        button.configuration = configuration
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
}

//MARK: -  Configure
private extension ContentsViewController {
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    func configureView() {
        [titleButton].forEach{ self.view.addSubview($0) }
        
        titleButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(300)
        }
    }
}
