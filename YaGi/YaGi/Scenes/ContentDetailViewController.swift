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
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var contentTextView: UITextView = {
        var textView = UITextView()
        
        var testText = ""
        for i in 1...10 {
            testText.append(contentsOf: """
                            상강은 한로(寒露)와 입동(立冬) 사이에 들며, 태양의 황경이 210도에 이를 때로 양력으로 10월 23일 무렵이 된다. 이 시기는 가을의 쾌청한 날씨가 계속되는 대신에 밤의 기온이 매우 낮아지는 때이다. 따라서 수증기가 지표에서 엉겨 서리가 내리며, 온도가 더 낮아지면 첫 얼음이 얼기도 한다.
                            """)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let attributedText = NSAttributedString(string:testText, attributes: attributes)
        
        textView.attributedText = attributedText
        textView.isEditable = false
        textView.text = testText
        textView.isScrollEnabled = false
        textView.textColor = .yagiGrayDeep
        textView.font = .maruburi(ofSize: 20, weight: .regular)
        
        return textView
    }()
    
    private lazy var menuBarItem: UIBarButtonItem = {
        var item = UIBarButtonItem()
        let action = UIAction { _ in
            print("Present Menu Bottom Sheet")
            
            var bottomMenuViewController = BottomMenuViewController()
            
            bottomMenuViewController.modalPresentationStyle = .overFullScreen
            bottomMenuViewController.modalTransitionStyle = .crossDissolve
            bottomMenuViewController = self.configureMenu(bottomMenuViewController)
            
            self.present(bottomMenuViewController, animated: true)
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
        item.tintColor = .yagiHighlight
        
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
        [contentTitle, contentView].forEach { scrollView.addSubview($0) }
        [contentTextView].forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(30)
            make.width.equalTo(300)
        }
        
        // TODO: - ContentView를 사용하지 않아도 잘 작동하는 것 같다.
        contentView.snp.makeConstraints { make in
            make.top.equalTo(contentTitle.snp.bottom).offset(40)
            make.bottom.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    func configureMenu(_ viewController: BottomMenuViewController) -> BottomMenuViewController {
        viewController.numberOfButtons = .third
        
        viewController.firMenuButtonTitle = "수정하기"
        viewController.secMenuButtonTitle = "공유하기"
        viewController.thrMenuButtonTitle = "삭제하기"
        
        viewController.firMenuButtonAction = {
            let contentWriteViewController = ContentWriteViewController()
            contentWriteViewController.modalPresentationStyle = .fullScreen
            
            self.dismiss(animated: true) {
                self.present(contentWriteViewController, animated: true)
            }
        }
        
        viewController.secMenuButtonAction = {
            let title: String = self.contentTitle.text ?? ""
            let text: String = self.contentTextView.text ?? ""
            let content: String = title.appending("\n\n" + text)
            let activityItems = [ShareActivityItemSource(title: title, content: content, placeholder: text)]
            
            self.dismiss(animated: true) {
                print("Present ActivityView")
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                activityViewController.completionWithItemsHandler = {(activity, isSuccess, returnedItems, error) in
                    if isSuccess {
                        print("Success")
                    } else {
                        print("Fail")
                    }
                }
                
                self.present(activityViewController, animated: true)
            }
        }
        
        viewController.thrMenuButtonAction = {
            self.dismiss(animated: true) {
                print("Present Alert")
            }
        }
        
        return viewController
    }
}

extension ContentDetailViewController: UIScrollViewDelegate {
    
}
