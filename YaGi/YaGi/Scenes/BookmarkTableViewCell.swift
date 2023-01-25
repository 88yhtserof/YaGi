//
//  BookmarkTableViewCell.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/24.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    //MARK: - View
    private lazy var bookmarkButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "bookmark.fill")
        configuration.baseForegroundColor = .yagiHighlight
        
        var bookmarkedButton = UIButton(configuration: configuration)
        
        return bookmarkedButton
    }()
    
    private lazy var contentTitle: UILabel = {
        var label = UILabel()
        label.text = "소제목24절기 중 첫째 절기로 대한(大寒)과 우수(雨水) 사이에 있는 절기. 보통 양력 2월 4일경에 해당한다. 태양의 황경(黃經)이 315도일 때로 이날부터 봄이 시작된다. 입춘은 음력으로 주로 정월에 드는데, 어떤 해는 정월과 섣달에 거듭 드는 때가 있다. 이럴 경우 ‘재봉춘(再逢春)’이라 한다."
        label.numberOfLines = 1
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 18, weight: .semiBold)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var contentDate: UILabel = {
        let label = UILabel()
        
        label.text = "2022.10.06 목"
        label.numberOfLines = 1
        label.textColor = .yagiGray
        label.font = .maruburi(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var contentText: UILabel = {
        var label = UILabel()
        label.text = "24절기 중 첫째 절기로 대한(大寒)과 우수(雨水) 사이에 있는 절기. 보통 양력 2월 4일경에 해당한다. 태양의 황경(黃經)이 315도일 때로 이날부터 봄이 시작된다. 입춘은 음력으로 주로 정월에 드는데, 어떤 해는 정월과 섣달에 거듭 드는 때가 있다. 이럴 경우 ‘재봉춘(再逢春)’이라 한다."
        label.numberOfLines = 3
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCell()
    }
}

//MARK: - Configure
private extension BookmarkTableViewCell {
    func configureCell() {
        
        [
            bookmarkButton,
            contentTitle,
            contentDate,
            contentText
        ]
            .forEach { self.addSubview($0) }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(10)
        }
                

        contentTitle.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.top)
            make.leading.equalToSuperview().inset(60)
            make.trailing.equalToSuperview().inset(15)
        }

        contentDate.snp.makeConstraints { make in
            make.top.equalTo(contentTitle.snp.bottom).offset(10)
            make.leading.equalTo(contentTitle)
        }

        contentText.snp.makeConstraints { make in
            make.top.equalTo(contentDate.snp.bottom).offset(10)
            make.leading.equalTo(contentTitle)
            make.trailing.equalTo(contentTitle)
        }
    }
}
