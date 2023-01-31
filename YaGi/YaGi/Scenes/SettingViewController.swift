//
//  MenuViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit

class SettingViewController: UIViewController {
    let book = UserDefaultsManager.books?.first
    
    private lazy var bookInfoContainerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 25)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor.yagiWhihtDeep.cgColor
        stackView.roundCorner(round: 15, [ .topRight, .topLeft, .bottomLeft, .bottomRight ])
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        guard let book = self.book else { return UILabel() }
        
        let text = "해리포터와 불의 잔"
        
        label.text = text
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 25, weight: .semiBold)
        label.numberOfLines = 3
        label.lineBreakStrategy = .hangulWordPriority
        
        return label
    }()
    
    private lazy var bookInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        guard let book = self.book else { return UILabel() }
        label.text = book.date
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 15, weight: .light)
        
        return label
    }()
    
    private lazy var numberOfChapterLabel: UILabel = {
        let label = UILabel()
        
        guard let contents = self.book?.contents else { return UILabel() }
        label.text = contents.count.description + "장"
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 15, weight: .light)
        
        return label
    }()
    
    private lazy var sendEmailButton: UIButton = {
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font : UIFont(name: "MaruBuri-SemiBold", size: 20) ?? UIFont()]
        )
        let attribitedTitle = AttributedString("문의하기", attributes: attributes)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attribitedTitle
        configuration.baseForegroundColor = .yagiGrayDeep
        configuration.image = UIImage(systemName: "envelope")
        configuration.imagePadding = 10.0
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private lazy var appVersionButton: UIButton = {
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font : UIFont(name: "MaruBuri-SemiBold", size: 20) ?? UIFont()]
        )
        let attribitedTitle = AttributedString("앱 버전 0.0.1", attributes: attributes)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attribitedTitle
        configuration.baseForegroundColor = .yagiGrayDeep
        configuration.image = UIImage(systemName: "info.circle")
        configuration.imagePadding = 10.0
        
        let button = UIButton(configuration: configuration)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var appInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var settingButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        
        [
            sendEmailButton,
            appVersionButton
        ]
            .forEach{ stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCell()
    }
}

private extension SettingViewController {
    func configureCell(){
        self.view.backgroundColor = .yagiWhite
        
        [
            dateLabel,
            numberOfChapterLabel
        ]
            .forEach{ bookInfoStackView.addArrangedSubview($0)}
        
        [
            titleLabel,
            bookInfoStackView
        ]
            .forEach { bookInfoContainerStackView.addArrangedSubview($0)}
        
        [
            bookInfoContainerStackView,
            settingButtonStackView
        ]
            .forEach{ view.addSubview($0) }
        
        bookInfoContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        settingButtonStackView.snp.makeConstraints{ make in
            make.top.equalTo(bookInfoContainerStackView.snp.bottom).offset(40)
            make.leading.equalTo(bookInfoContainerStackView)
        }
    }
}
