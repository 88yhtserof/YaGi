//
//  ContentsViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/09/17.
//

import UIKit

class ContentsViewController: UIViewController {
    //MARK: - Properties
    // TODO: - 데이터 연결에 따른 프로퍼티 정리
    private let indexOfCurrentBook: Int = 0
    private var contentsCollectionItems: [ContentsCollectionItemModel] = []
    
    //MARK: - View
    private lazy var menuBarItem: UIBarButtonItem = {
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
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        
        let paragraphTitle = NSMutableParagraphStyle()
        paragraphTitle.lineSpacing = 10
        paragraphTitle.lineBreakStrategy = .hangulWordPriority
        
        let attributes = [NSAttributedString.Key.paragraphStyle : paragraphTitle]
        let attributeTitle = NSAttributedString(string: "제목", attributes: attributes)
        
        label.attributedText = attributeTitle
        label.font = .maruburi(ofSize: 30, weight: .bold)
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
            let writingViewController = WritingViewController(sectionType: .contents,contentIndex: nil, isEditMode: false)
            writingViewController.modalPresentationStyle = .fullScreen
            
            self.present(writingViewController, animated: true)
        }
        
        button.configuration = configuration
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentsCollectionView: UICollectionView = {
        let layout = self.layout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(DraftCollectionViewCell.self, forCellWithReuseIdentifier: "DraftCollectionViewCell")
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: "ContentsCollectionViewCell")
        
       return collectionView
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

//MARK: -  Configure
private extension ContentsViewController {
    func configureData(){
        guard let book = BookRepository().fetch(at: self.indexOfCurrentBook) else { return }
        
        self.titleLabel.text = book.title
        
        //contentsCollectionItemModel 데이터 연결
        let drafts = DraftRepository().fetchAll()
        let draftItems = ContentsCollectionItemModel(sectionType: .draft, items: drafts)
        
        let chapters = ChapterRepository().fetchAll()
        let chapterItems = ContentsCollectionItemModel(sectionType: .contents  , items: chapters)
    
        self.contentsCollectionItems = [draftItems, chapterItems]
        
        self.contentsCollectionView.reloadData()
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
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - CollectionView DataSource, Delegate
extension ContentsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contentsCollectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentsCollectionItems[section].items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contentsCollectionItems[indexPath.section].sectionType {
        case .draft:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DraftCollectionViewCell", for: indexPath) as? DraftCollectionViewCell else { return UICollectionViewCell() }
            
            guard let drafts = contentsCollectionItems[indexPath.section].items as? [Draft] else { return UICollectionViewCell() }
            let draft = drafts[indexPath.row]
            
            cell.configureCellData(draftTitle: draft.heading ?? "")
            return cell
            
        case .contents:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentsCollectionViewCell", for: indexPath) as? ContentsCollectionViewCell
            else { return UICollectionViewCell() }
            
            guard let chapters = contentsCollectionItems[indexPath.section].items as? [Chapter] else { return UICollectionViewCell() }
            let chapter = chapters[indexPath.row]
            cell.configureCell(title: chapter.heading ?? "", date: chapter.date ?? "")
            return cell
        }
    }
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch contentsCollectionItems[indexPath.section].sectionType {
        case .draft:
            let writingVC = WritingViewController(sectionType: .draft, contentIndex: indexPath.row, isEditMode: true)
            writingVC.modalPresentationStyle = .fullScreen
            
            self.present(writingVC, animated: true)
        case .contents:
            let selectedContentIndex = indexPath.row
            let contentDetailViewController = ContentDetailViewController(contentIndex: selectedContentIndex)
            
            contentDetailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(contentDetailViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let section = indexPath.section
        let row = indexPath.row
        let sectionType = contentsCollectionItems[section].sectionType
        
        if sectionType == .draft {
            return UIContextMenuConfiguration(actionProvider: { suggestedAction in
                return UIMenu(children: [
                    // TODO: - 임시저장 글 공유하기
                    
                    //Draft 삭제
                    UIAction(title: "삭제하기", attributes: .destructive, handler: { _ in
                        guard let draft = self.contentsCollectionItems[section].items?[row] as? Draft
                        else { return }
                        
                        DraftRepository().remove(draft)
                        self.contentsCollectionItems[section].items?.remove(at: row)
                        
                        collectionView.deleteItems(at: [indexPath])
                    })
                ])
            })
        }
        else {
            return nil
        }
    }
}

//MARK: - Collection Layout
private extension ContentsViewController {
    func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch self.contentsCollectionItems[sectionNumber].sectionType {
            case .draft:
                let sectionIsEmpty = self.contentsCollectionItems[sectionNumber].items?.isEmpty ?? true
                if sectionIsEmpty {
                    return self.createEmptySectionLayout()
                }
                else {
                    return self.createDraftSectionLayout()
                }
            case.contents:
                return self.createContentsSectionLayout()
            }
        }
        
        return layout
    }
    
    func createDraftSectionLayout() -> NSCollectionLayoutSection {
        //size
        let sizeItem = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let sizeGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(50))
        
        //item
        let item = NSCollectionLayoutItem(layoutSize: sizeItem)
        
        //group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: sizeGroup, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
        
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

    func createEmptySectionLayout() -> NSCollectionLayoutSection {
        //size
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(0.0))
        
        //item
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        //group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
