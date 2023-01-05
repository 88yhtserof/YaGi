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
    
    private lazy var writingView: UITextView = {
        let textView = UITextView()
        
        var testText = ""
        for i in 1...10 {
            testText.append(contentsOf: """
                            상강은 한로(寒露)와 입동(立冬) 사이에 들며, 태양의 황경이 210도에 이를 때로 양력으로 10월 23일 무렵이 된다. 이 시기는 가을의 쾌청한 날씨가 계속되는 대신에 밤의 기온이 매우 낮아지는 때이다. 따라서 수증기가 지표에서 엉겨 서리가 내리며, 온도가 더 낮아지면 첫 얼음이 얼기도 한다.
                            """)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let attributedText = NSAttributedString(string:testText, attributes: attributes)
        
        textView.attributedText = attributedText
        textView.isEditable = true
        textView.text = testText
        textView.isScrollEnabled = false
        textView.textColor = .yagiGrayDeep
        textView.font = .maruburi(ofSize: 20, weight: .regular)
        
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
        
        writingView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(offset)
            make.bottom.equalToSuperview().inset(inset)
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
}

extension WritingViewController: UIScrollViewDelegate {}
