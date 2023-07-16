//
//  CSDetailView.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/07/16.
//

import UIKit

import SnapKit

class CSDetailView: UIView {
    
    //MARK: - View
    private var contentView = UIView()
    var scrollView = UIScrollView()
    var contentTitle = UILabel()
    var contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - Configure
private extension CSDetailView {
    
    func configure() {
        scrollView.backgroundColor = .yagiWhite
        
        contentTitle.attributedText = configureString()
        contentTitle.font = .maruburi(ofSize: 20, weight: .bold)
        contentTitle.textColor = .yagiGrayDeep
        contentTitle.minimumScaleFactor = 0.9
        contentTitle.adjustsFontSizeToFitWidth = true
        contentTitle.numberOfLines = 0
        
        contentLabel.attributedText = configureString()
        contentLabel.font = .maruburi(ofSize: 20, weight: .regular)
        contentLabel.textColor = .yagiGrayDeep
        contentLabel.numberOfLines = 0
        
    }
    
    func configureString() -> NSAttributedString {
        let text = "제목"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes = [ NSAttributedString.Key.paragraphStyle : paragraphStyle ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func layout() {
        
        [scrollView].forEach { self.addSubview($0) }
        [contentTitle, contentView].forEach { scrollView.addSubview($0) }
        [contentLabel].forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(300)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(contentTitle.snp.bottom).offset(30)
            make.bottom.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

