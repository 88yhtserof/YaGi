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
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .yagiHighlight
        
        let languge = Locale.preferredLanguages.first ?? "en-US"
        datePicker.locale = Locale(identifier: languge)
        
        return datePicker
        
    }()
    
    private lazy var contentTitleTextView: UITextView = {
        let textView = UITextView()
        let text = "제목을 입력하세요"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let attributedText = NSAttributedString(string:text, attributes: attributes)
        
        textView.attributedText = attributedText
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textColor = .placeholderText
        textView.font = .maruburi(ofSize: 25, weight: .bold)
        
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var writingView: UITextView = {
        let textView = UITextView()
        
        var text = "내용을 입력하세요"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let attributedText = NSAttributedString(string:text, attributes: attributes)
        
        textView.attributedText = attributedText
        textView.isEditable = true
        textView.text = text
        textView.isScrollEnabled = false
        textView.textColor = .placeholderText
        textView.font = .maruburi(ofSize: 20, weight: .regular)
        
        textView.delegate = self
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
}

private extension WritingViewController {
    
    func configureView() {
        self.view.backgroundColor = .yagiWhite
        
        view.addSubview(scrollView)
        
        [
            cancelButton,
            datePicker,
            contentTitleTextView,
            writingView
        ]
            .forEach { scrollView.addSubview($0) }
        
        let inset: Int = 25
        let offset: Int = 20
        
        scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(inset)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(inset)
            make.centerX.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(offset)
            make.leading.equalToSuperview()
        }
        
        contentTitleTextView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview()
        }
        
        writingView.snp.makeConstraints { make in
            make.top.equalTo(contentTitleTextView.snp.bottom).offset(offset)
            make.bottom.equalToSuperview().inset(inset)
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
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
}
