//
//  WritingViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit
import SnapKit

class WritingViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.delegate = self
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
       let view = UIView()
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "multiply")
        configuration.baseForegroundColor = .yagiGray
        
        let action = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        button.configuration = configuration
        button.addAction(action, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "checkmark")
        configuration.baseForegroundColor = .yagiHighlight
        
        let action = UIAction { _ in
            self.dismiss(animated: true)
        }
        
        button.configuration = configuration
        button.addAction(action, for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .yagiHighlight
        
        let languge = Locale.preferredLanguages.first ?? "en-US"
        datePicker.locale = Locale(identifier: languge)
        
        return datePicker
        
    }()
    
    private lazy var doneBarItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(systemItem: .done)
        
        barItem.tintColor = .yagiHighlight
        let action = UIAction { _ in
            self.view.endEditing(true)
        }
        barItem.primaryAction = action
        
        return barItem
    }()
    
    private lazy var keyboardToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        
        toolBar.sizeToFit()
        toolBar.isTranslucent = true
        toolBar.setItems([doneBarItem], animated: true)
        
        return toolBar
    }()
    
    private lazy var contentTitleTextView: UITextView = {
        let textView = UITextView()
        let text = "제목을 입력하세요"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let attributedText = NSAttributedString(string:text, attributes: attributes)
        
        textView.attributedText = attributedText
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textColor = .placeholderText
        textView.font = .maruburi(ofSize: 25, weight: .bold)
        textView.inputAccessoryView = keyboardToolBar
        
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var writingView: UITextView = {
        let textView = UITextView()
        
        var text = "내용을 입력하세요"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let attributedText = NSAttributedString(string:text, attributes: attributes)
        
        textView.attributedText = attributedText
        textView.isEditable = true
        textView.text = text
        textView.isScrollEnabled = false
        textView.textColor = .placeholderText
        textView.font = .maruburi(ofSize: 20, weight: .regular)
        textView.inputAccessoryView = keyboardToolBar
        
        textView.delegate = self
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        registerKeyboardNotifications()
    }
}

private extension WritingViewController {
    
    func configureView() {
        self.view.backgroundColor = .yagiWhite
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            cancelButton,
            saveButton,
            datePicker,
            contentTitleTextView,
            writingView
        ]
            .forEach { contentView.addSubview($0) }
        
        let inset: Int = 25
        let offset: Int = 20
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(offset)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(inset)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(offset)
            make.leading.equalToSuperview().inset(inset)
        }
        
        contentTitleTextView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
        
        writingView.snp.makeConstraints { make in
            make.top.equalTo(contentTitleTextView.snp.bottom).offset(offset)
            make.bottom.equalToSuperview().inset(inset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
    }
}

extension WritingViewController: UIScrollViewDelegate {}

extension WritingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == UIColor.placeholderText else{ return }
        
        textView.text = ""
        textView.textColor = .yagiGrayDeep
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else { return }
        
        textView.text = textView == self.contentTitleTextView ? "제목을 입력하세요" : "내용을 입력하세요"
        textView.textColor = .placeholderText
    }
}

//MARK: - Adjust the view displaying the text
private extension WritingViewController {
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}
