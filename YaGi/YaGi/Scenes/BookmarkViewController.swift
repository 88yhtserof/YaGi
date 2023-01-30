//
//  BookmarkTableViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/24.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    var book: BookModel?
    var bookmarkedContents: [ContentModel]?
    
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
                guard var book = self.book,
                      var contents = book.contents,
                      var bookmarkedContents = self.bookmarkedContents
                else { return }
                
                let unbookmarkedContents = contents.map {
                    if $0.bookmark {
                        var content = $0
                        content.bookmark = false
                        return content
                    }
                    return $0
                }
                
                bookmarkedContents.removeAll()
                book.contents = unbookmarkedContents
                book.bookmarkedContents = bookmarkedContents
                
                UserDefaultsManager.books = [book]
                self.bookmarkedContents = bookmarkedContents
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

private extension BookmarkViewController {
    func configureData(){
        guard let books = UserDefaultsManager.books,
              let book = books.first,
              let bookmarkedContents = book.bookmarkedContents
        else { return }
        
        self.book = book
        self.bookmarkedContents = bookmarkedContents
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
        guard let numberOfRow = bookmarkedContents?.count else { return 0 }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let bookmarkedContents = self.bookmarkedContents,
              let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as? BookmarkTableViewCell
        else { return UITableViewCell() }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .yagiWhihtDeep
        cell.selectedBackgroundView = backgroundView
        
        let content = bookmarkedContents[indexPath.row]
        cell.configureData(content)
        
        return cell
    }
}

//MARK: - TableView Delegate
extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = self.book,
              let bookmarkedContent = self.bookmarkedContents?[indexPath.row]
        else { return }
        
        let contentDetailViewController = ContentDetailViewController(book: book, content: bookmarkedContent)
        self.navigationController?.pushViewController(contentDetailViewController, animated: true)
    }
}
