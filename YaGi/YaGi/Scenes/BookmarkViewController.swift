//
//  BookmarkTableViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/24.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    private lazy var unbookmarkAllBarButton: UIBarButtonItem = {
        var item = UIBarButtonItem()
        let action = UIAction { _ in
            print("Present Alert")
        }
        
        item.primaryAction = action
        item.title = "전체 해제"
        
        return item
    }()
    
    private lazy var bookmarkTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.dataSource = self
        tableView.rowHeight = 130
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCell")
        
        configureNavigationBar()
        configureView()
    }
}

private extension BookmarkViewController {
    func configureNavigationBar(){
        self.navigationItem.rightBarButtonItem = unbookmarkAllBarButton
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as? BookmarkTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
