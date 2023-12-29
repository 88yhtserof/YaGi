//
//  ContentDetailViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit

class ContentDetailViewController: UIViewController {
    
    //MARK: - Properties
    private let indexOfCurrentBook: Int = 0
    private var books: [BookModel]?
    private var chapter: Chapter?
    private var contentIndex: Int
    
    init(contentIndex: Int) {
        self.contentIndex = contentIndex
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View
    private var detailView = CSDetailView()
    
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
            
            var isBookmark = false
            
            switch item.tintColor {
            case bookmarkedState:
                isBookmark = true
            case unbookmarkedState:
                isBookmark = false
            case .none:
                break
            case .some(_):
                break
            }
            
            guard var chapter = self.chapter else { return }
            ChapterRepository().updateBookmark(chapter, isBookmark)
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
        guard let chapter = ChapterRepository().fetch(at: self.contentIndex) else { return }
        
        self.chapter = chapter
        self.bookmarkBarItem.tintColor = chapter.bookmark ? .yagiHighlight : .yagiHighlightLight
        self.detailView.contentTitle.text = chapter.heading ?? ""
        self.detailView.contentLabel.text = chapter.content ?? ""
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItems = [menuBarItem, bookmarkBarItem]
    }
    
    func configureView() {
        self.view.backgroundColor = .yagiWhite
  
        [detailView].forEach { self.view.addSubview($0) }
        
        detailView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureMenu(_ viewController: BottomMenuViewController) -> BottomMenuViewController {
        viewController.numberOfButtons = .fourth
        
        viewController.firMenuButtonTitle = "수정하기"
        viewController.secMenuButtonTitle = "삭제하기"
        viewController.thrMenuButtonTitle = "텍스트 공유하기"
        viewController.fthMenuButtonTitle = "이미지 공유하기"
        
        //수정하기
        viewController.firMenuButtonAction = {
            let contentWriteViewController = WritingViewController(sectionType: .contents, contentIndex: self.contentIndex, isEditMode: true)
            contentWriteViewController.modalPresentationStyle = .fullScreen
            
            self.dismiss(animated: true) {
                self.present(contentWriteViewController, animated: true)
            }
        }
        
        //삭제하기
        viewController.secMenuButtonAction = {
            self.dismiss(animated: true) {
                let removeAction = UIAlertAction(title: "삭제", style: .destructive) {_ in
                    guard let chapter = self.chapter else { return }
                    ChapterRepository().remove(chapter)
                    
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
        
        //텍스트 공유하기
        viewController.thrMenuButtonAction = {
            let title: String = self.detailView.contentTitle.text ?? ""
            let text: String = self.detailView.contentLabel.text ?? ""
            let content: String = title.appending("\n\n" + text)
            let activityItems = [ShareActivityItemSource(title: title, content: content, placeholder: text)]
            
            let activityVC = UIActivityViewController(self, activityItems: activityItems, applicationActivities: nil)
            
            activityVC.completionWithItemsHandler = {(activity, isSuccess, returnedItems, error) in
                if isSuccess {
                    print("Success")
                } else {
                    print("Fail")
                }
            }
            
            self.dismiss(animated: true) {
                self.present(activityVC, animated: true)
            }
        }
        
        //이미지 공유하기
        viewController.fthMenuButtonAction = {
            guard let shareImage = self.view.snapShotFullScreen(scrollView: self.detailView.scrollView) else { return }
            let activityItems = [ shareImage ]
            
            let activityVC = UIActivityViewController(self, activityItems: activityItems, applicationActivities: nil)
            
            activityVC.completionWithItemsHandler = { activity, isSuccess, returnedItem, error in
                if isSuccess {
                    print("Success")
                } else {
                    print("Fail")
                }
            }
            
            self.dismiss(animated: true) {
                self.present(activityVC, animated: true)
            }
        }
        
        return viewController
    }
}

extension ContentDetailViewController: UIScrollViewDelegate {
    
}
