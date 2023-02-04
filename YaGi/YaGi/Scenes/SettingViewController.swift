//
//  MenuViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {
    let book = UserDefaultsManager.books?.first
    
    private lazy var lineView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .yagiHighlight
        view.layer.shadowColor = UIColor.yagiWhihtDeep.cgColor
        view.alpha = 0.5
        
        view.layer.shadowColor = UIColor.yagiWhihtDeep.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        
        return view
    }()
    
    private lazy var bookInfoContainerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 15
        
        stackView.layoutMargins = UIEdgeInsets(top: 25, left: 25, bottom: 45, right: 25)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        guard let book = self.book else { return UILabel() }
        let text = book.title
        
        label.text = text
        label.textAlignment = .center
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 25, weight: .bold)
        label.numberOfLines = 4
        label.lineBreakStrategy = .hangulWordPriority
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var bookInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        guard let book = self.book else { return UILabel() }
        label.text = book.date
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 15, weight: .semiBold)
        
        return label
    }()
    
    private lazy var numberOfChapterLabel: UILabel = {
        let label = UILabel()
        
        guard let contents = self.book?.contents else { return UILabel() }
        label.text = contents.count.description + "장"
        label.textColor = .yagiGrayDeep
        label.font = .maruburi(ofSize: 15, weight: .semiBold)
        
        return label
    }()
    
    private lazy var sendEmailButton: UIButton = {
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font : UIFont(name: "MaruBuri-Regular", size: 20) ?? UIFont()]
        )
        let attribitedTitle = AttributedString("문의하기", attributes: attributes)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attribitedTitle
        configuration.baseForegroundColor = .yagiGrayDeep
        configuration.image = UIImage(systemName: "envelope")
        configuration.imagePadding = 10.0
        
        let action = UIAction { _ in
            if !MFMailComposeViewController.canSendMail() {
                let alert = UIAlertController(title: "메일을 보낼 수 없습니다", message: "기기에 email이 등록되어 있는지 확인바랍니다.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true)
                return
            }
            
            var mailComposeVC = MFMailComposeViewController()
            mailComposeVC.delegate = self
            mailComposeVC.mailComposeDelegate = self
            
            guard let privacyInfoList = Bundle.main
                .object(forInfoDictionaryKey: "Privacy Info list") as? [String:String],
               let developerEmail = privacyInfoList["Developer email"]
            else { return }
            
            mailComposeVC.setToRecipients([developerEmail])
            mailComposeVC.setSubject("[야기] 문의드립니다.")
            self.present(mailComposeVC, animated: true)
        }
        
        let button = UIButton(configuration: configuration)
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var appVersionButton: UIButton = {
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font : UIFont(name: "MaruBuri-Regular", size: 20) ?? UIFont()]
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
    
    private lazy var settingButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
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
        
        configureView()
    }
}

private extension SettingViewController {
    func configureView(){
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
            lineView,
            settingButtonStackView
        ]
            .forEach{ view.addSubview($0) }
        
        bookInfoContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints{ make in
            make.top.equalTo(bookInfoContainerStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(1.5)
        }
        
        settingButtonStackView.snp.makeConstraints{ make in
            make.top.equalTo(lineView.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
    }
}

//MARK: - MFMailComposeViewController Delegate
extension SettingViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
