//
//  StartViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/10.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {
    //MARK: - View
    private lazy var appTitleLabel: UILabel =  {
        let label = UILabel()
        
        label.text = "야기"
        label.font = .maruburi(ofSize: 35, weight: .bold)
        label.textColor = .yagiGrayDeep
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let text = "시, 소설, 일기, 에세이 등 \n 당신만의 이야기를 시작해보세요."
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 7.0
        
        let attributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.paragraphStyle : paragraph ]
        let attributeText = NSAttributedString(string: text, attributes: attributes)
        
        label.attributedText = attributeText
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .maruburi(ofSize: 15, weight: .regular)
        label.textColor = .yagiGrayDeep
        
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "제목을 입력하세요"
        textField.font = .maruburi(ofSize: 20, weight: .semiBold)
        textField.textColor = .yagiGrayDeep
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.tintColor = .yagiHighlight
        textField.clearButtonMode = .whileEditing

        let action = UIAction { _ in
            guard let text = textField.text else { return }
            if text.isEmpty {
                self.doneButton.isEnabled = false
                return
            }
            self.doneButton.isEnabled = true
        }
        textField.addAction(action, for: .editingChanged)
        
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        
        configuration.image = UIImage(systemName: "checkmark")
        configuration.baseForegroundColor = .yagiHighlight
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 30, bottom: 30, trailing: 30)
        
        let action = UIAction {  _ in
            
            let book = self.createBook()
            UserDefaultsManager.books = [book]
            
            let bookshelfController = UINavigationController(rootViewController: BookshelfViewController())
            SceneDelegate.shared.updateRootViewController(bookshelfController)
        }
        
        button.configuration = configuration
        button.addAction(action, for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //MARK: - Function
    private func createBook() -> BookModel {
        let title = self.titleTextField.text ?? String()
        
        let dateFormatter = DateFormatter()
        let localeID = Locale.preferredLanguages.first ?? "en-US"
        dateFormatter.dateFormat = "yyyy.MM.dd E"
        dateFormatter.locale = Locale(identifier: localeID)
        let date = dateFormatter.string(from: Date())
        
        return BookModel(date: date, title: title)
    }
}

//MARK: - Configure
private extension StartViewController {
    func configureView(){
        self.view.backgroundColor = .yagiWhite
        
        [
            appTitleLabel,
            descriptionLabel,
            titleTextField,
            doneButton
        ]
            .forEach { view.addSubview($0) }
        
        appTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(appTitleLabel.snp.bottom).offset(18)
            make.centerX.equalTo(appTitleLabel.snp.centerX)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }
}

//MARK: - Adjust Keyboard
extension StartViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}
