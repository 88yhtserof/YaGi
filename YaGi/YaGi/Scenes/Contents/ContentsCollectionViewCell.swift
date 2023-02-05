//
//  ContentsCollectionViewCell.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/06.
//

import UIKit

class ContentsCollectionViewCell: UICollectionViewCell {
    private lazy var contentTitle: UILabel = {
        let label = UILabel()
        
        label.text = "1. 예약하신 용이 도착하였습니다"
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureCell(title: String, date: String) {
        contentView.backgroundColor = .yagiWhite
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.yagiWhihtDeep.cgColor
        
        layer.shadowColor = UIColor.yagiWhihtDeep.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 3
        
        self.contentTitle.text = title
        self.contentDate.text = date
        
        [contentTitle, contentDate].forEach { self.contentView.addSubview($0) }
        
        contentTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
        }
        
        contentDate.snp.makeConstraints { make in
            make.leading.equalTo(contentTitle.snp.leading)
            make.trailing.equalTo(contentTitle.snp.trailing)
            make.top.equalTo(contentTitle.snp.bottom).offset(3)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
