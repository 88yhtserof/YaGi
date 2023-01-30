//
//  ContentDetailViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    //MARK: - Properties
    var book: BookModel
    var content: ContentModel
    
    init(book: BookModel, content: ContentModel) {
        self.book = book
        self.content = content
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        scroll.delegate = self
        
        return scroll
    }()
    
    private lazy var contentTitle: UILabel = {
        var label = UILabel()
        
        label.text = self.content.contentTitle
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
        
        var text = self.content.contentText
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let attributedText = NSAttributedString(string:text, attributes: attributes)
        
        textView.attributedText = attributedText
        textView.isEditable = false
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
            let bookmarkedState = UIColor.yagiHighlight
            let unbookmarkedState = UIColor.yagiHighlightLight
            
            item.tintColor = item.tintColor == unbookmarkedState ? bookmarkedState : unbookmarkedState
            self.view.layoutIfNeeded()
            
            var bookmarkedContents = self.book.bookmarkedContents ?? []
            
            switch item.tintColor {
            case bookmarkedState:
                self.content.bookmark = true
                bookmarkedContents.append(self.content)
            case unbookmarkedState:
                self.content.bookmark = false
                if let bookmarkedIndex = bookmarkedContents.firstIndex (where: {$0.contentIndex == self.content.contentIndex}) {
                    bookmarkedContents.remove(at: bookmarkedIndex)
                }
            case .none:
                break
            case .some(_):
                break
            }
            
            self.book.contents?[self.content.contentIndex] = self.content
            self.book.bookmarkedContents = bookmarkedContents
            guard var books = UserDefaultsManager.books else { return }
            let indexOfCurrentBook: Int = 0
            books[indexOfCurrentBook] = self.book
            UserDefaultsManager.books = books
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureData()
    }
}

//MARK: - Configure
private extension ContentDetailViewController {
    func configureData(){
        //글 수정 후 dismiss할 때 데이터 연결을 위한 코드
        guard let books = UserDefaultsManager.books,
              let contents = books[0].contents
        else { return }
        let content = contents[self.content.contentIndex]
        
        self.bookmarkBarItem.tintColor = content.bookmark ? .yagiHighlight : .yagiHighlightLight
        self.contentTitle.text = content.contentTitle
        self.contentTextView.text = content.contentText
    }
    
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
            let contentWriteViewController = WritingViewController(book: self.book, content: self.content, isEditMode: true)
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
                let removeAction = UIAlertAction(title: "삭제", style: .destructive) {_ in
                    guard var contents = self.book.contents else { return }
                    contents.remove(at: self.content.contentIndex)
                    self.book.contents = contents
                    UserDefaultsManager.books = [self.book]
                    
                    self.navigationController?.popViewController(animated: true)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel) {_ in
                    self.dismiss(animated: true)
                }
                
                let alert = UIAlertController(title: "삭제하시겠습니까?", message: "영구 삭제되어 복구할 수 없습니다.", preferredStyle: .alert)
                
                [
                    removeAction,
                    cancelAction
                ]
                    .forEach { alert.addAction($0) }
                
                self.present(alert, animated: true)
            }
        }
        
        return viewController
    }
}

extension ContentDetailViewController: UIScrollViewDelegate {
    
}
