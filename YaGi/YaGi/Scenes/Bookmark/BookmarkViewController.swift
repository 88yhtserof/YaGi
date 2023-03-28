//
//  BookmarkTableViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/24.
//

import UIKit

class BookmarkViewController: UIViewController {
    //MARK: - Properties
    private var chapters: [Chapter]?
    private var bookmarkedChapters: [Chapter]?
    
    //MARK: -  View
    private lazy var unbookmarkAllBarButton: UIBarButtonItem = {
        var item = UIBarButtonItem()
        let action = UIAction { _ in
            let alertController = UIAlertController(
                title: "전체 해제하시겠습니다?",
                message: "글 상세 화면에서 다시 책갈피를 꽂을 수 있습니다.",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let clearAction = UIAlertAction(title: "해제", style: .destructive) { _ in
                
                guard let bookmarkedChapters = self.bookmarkedChapters else { return }
                
                ChapterRepository().unbookmarkAll(bookmarkedChapters)
                
                self.bookmarkedChapters?.removeAll()
                self.bookmarkTableView.reloadData()
            }
            
            [
                cancelAction,
                clearAction
            ]
                .forEach{ alertController.addAction($0) }
            
            self.present(alertController, animated: true)
        }
        
        item.primaryAction = action
        item.title = "전체 해제"
        
        return item
    }()
    
    private lazy var bookmarkTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 130
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCell")
        
        configureNavigationBar()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureData()
    }
}

//MARK: - Configure
private extension BookmarkViewController {
    func configureData(){
        guard let chapters = ChapterRepository().fetchAll() else { return }
        self.chapters = chapters
        
        self.bookmarkedChapters = chapters.filter{ chapter -> Bool in
            return chapter.bookmark
        }
        
        bookmarkTableView.reloadData()
    }
    
    func configureNavigationBar(){
        self.navigationItem.rightBarButtonItem = unbookmarkAllBarButton
        self.navigationItem.title = ""
    }
    
    func configureView(){
        [
            bookmarkTableView
        ]
            .forEach { self.view.addSubview($0)}
        
        bookmarkTableView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - TableView DataSource
extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedChapters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let bookmarkedChapters = self.bookmarkedChapters,
              let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as? BookmarkTableViewCell
        else { return UITableViewCell() }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .yagiWhihtDeep
        cell.selectedBackgroundView = backgroundView
        
        let chapter = bookmarkedChapters[indexPath.row]
        cell.configureData(chapter)
        
        return cell
    }
}

//MARK: - TableView Delegate
extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chapters = self.chapters,
              let bookmarkedChapters = self.bookmarkedChapters else { return }
        
        let chapterIndex = chapters.firstIndex { chapter in
            let bookmarkedChapter = bookmarkedChapters[indexPath.row]
            return chapter == bookmarkedChapter
        }
        guard let index = chapterIndex else { return }
        
        let contentDetailViewController = ContentDetailViewController(contentIndex: index)
        self.navigationController?.pushViewController(contentDetailViewController, animated: true)
    }
}
