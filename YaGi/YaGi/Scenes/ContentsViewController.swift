//
//  ContentsViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/09/17.
//

import UIKit

class ContentsViewController: UIViewController {
    //MARK: - Properties
    private let indexOfCurrentBook: Int = 0
    private var book: BookModel = BookModel(title: String())
    private var contents: [ContentModel] = []
    private var bookTitle: String = String()
    
    //MARK: - View
    private lazy var menuBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        let action = UIAction {_ in 
            let menuViewController = MenuViewController()
            self.navigationController?.pushViewController(menuViewController, animated: true)
        }
        
        item.primaryAction = action
        item.image = UIImage(systemName: "ellipsis")
        item.tintColor = .yagiGray
        
        return item
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        
        let paragraphTitle = NSMutableParagraphStyle()
        paragraphTitle.lineSpacing = 10
        paragraphTitle.lineBreakStrategy = .hangulWordPriority
        
        let attributes = [NSAttributedString.Key.paragraphStyle : paragraphTitle]
        let attributeTitle = NSAttributedString(string: self.bookTitle, attributes: attributes)
        
        label.attributedText = attributeTitle
        label.font = .maruburi(ofSize: 35, weight: .bold)
        label.textColor = UIColor.yagiGrayDeep
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    private lazy var titleButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()

        var attributedTitle = AttributedString("이야기 추가하기")
        attributedTitle.font = .maruburi(ofSize: 15, weight: .regular)
        attributedTitle.foregroundColor = UIColor.yagiHighlight

        configuration.attributedTitle = attributedTitle
        configuration.image = UIImage(systemName: "text.badge.plus")
        configuration.imagePadding = 3
        configuration.imagePlacement = .trailing
        configuration.buttonSize = .mini
        configuration.imageColorTransformer = .init({_ in return UIKit.UIColor.yagiHighlight})
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 50)
        
        let action = UIAction { action  in
            let writingViewController = WritingViewController()
            writingViewController.modalPresentationStyle = .fullScreen
            
            self.present(writingViewController, animated: true)
        }
        
        button.configuration = configuration
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = self.layout()
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: "ContentsCollectionViewCell")
        
       return collectionView
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureData()
        configureView()
    }
}

//MARK: -  Configure
private extension ContentsViewController {
    func configureData(){
        guard let book = UserDefaultsManager.books?[indexOfCurrentBook] as? BookModel else { return }
        self.book = book
        self.bookTitle = book.title
        
        guard let contents = book.contents else { return }
        self.contents = contents
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = menuBarItem
        self.navigationItem.title = ""
    }
    
    func configureView() {
        [
            titleLabel,
            titleButton,
            contentsCollectionView
        ]
            .forEach{ self.view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(25)
            make.trailing.equalToSuperview().inset(50)
        }
        
        titleButton.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(25)
        }
        
        contentsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}

//MARK: - CollectionView DataSource, Delegate
extension ContentsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentsCollectionViewCell", for: indexPath) as? ContentsCollectionViewCell
        else { return UICollectionViewCell() }

        let content = contents[indexPath.row]
        cell.configureCell(title: content.contentTitle, date: content.ContentDate)
        
        return cell
    }
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contentDetailViewController = ContentDetailViewController()
        
        contentDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(contentDetailViewController, animated: true)
    }
}

//MARK: - Collection Layout
private extension ContentsViewController {
    func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(section: createContentsSectionLayout())
        
        return layout
    }
    
    func createContentsSectionLayout() -> NSCollectionLayoutSection {
        //size
        let sizeItem = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let sizeGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        //item
        let item = NSCollectionLayoutItem(layoutSize: sizeItem)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        //group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: sizeGroup, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 20, trailing: 10)
        
        return section
    }
}
