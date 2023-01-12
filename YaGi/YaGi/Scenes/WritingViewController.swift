//
//  WritingViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit
import SnapKit

class WritingViewController: UIViewController {
    
    //MARK: - Properties
    var book: BookModel?
    let content: ContentModel?
    let contentIndex: Int?
    
    var isEditMode: Bool = false
    let userDefault = UserDefaults.standard
    var contentTitle: String = "제목을 입력하세요"
    var contentText: String = "내용을 입력하세요"
    var contentDate: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd E"
        let languge = Locale.preferredLanguages.first ?? "en-US"
        dateFormatter.locale = Locale(identifier: languge)
        
        return dateFormatter.string(from: Date())
    }()
    
    init(book: BookModel?, content: ContentModel?, contentIndex: Int?, isEditMode: Bool) {
        self.book = book
        self.content = content
        self.contentIndex = contentIndex
        self.isEditMode = isEditMode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View
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
            let content = self.createContent(title: self.contentTitle, text: self.contentText)
            self.saveContent(content)
            
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
        
        let action = UIAction { _ in
            let date = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd E"
            let languge = Locale.preferredLanguages.first ?? "en-US"
            dateFormatter.locale = Locale(identifier: languge)
            
            self.contentDate = dateFormatter.string(from: date)
        }
        datePicker.addAction(action, for: .valueChanged)
        
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
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        
        toolBar.sizeToFit()
        toolBar.isTranslucent = true
        toolBar.setItems([doneBarItem], animated: true)
        
        return toolBar
    }()
    
    private lazy var contentTitleTextView: UITextView = {
        let textView = UITextView()
        let text = self.contentTitle
        
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
        
        var text = self.contentText
        
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
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        registerKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isEditMode {
            configureData()
        }
    }
    
    //MARK: - Function
    func createContent(title: String, text: String) -> ContentModel {
        
        let content = ContentModel(
            contentTitle: title,
            ContentDate: self.contentDate,
            contentText: text
        )
        
        return content
    }
    
    func saveContent(_ content: ContentModel) {
        let indexOfCurrentBook: Int = 0
        
        guard var books = UserDefaultsManager.books else { return }
        var book = books[indexOfCurrentBook] //현 시즌에서는 책은 한 권만 존재한다.
        
        switch isEditMode {
        case false:
            if book.contents == nil {
                book.contents = Array<ContentModel>()
            }
            book.contents?.append(content)
        case true:
            print("Insert a edited content into book")
        }
        
        books[indexOfCurrentBook] = book
        UserDefaultsManager.books = books
    }
}

//MARK: - Configure
private extension WritingViewController {
    
    func configureData(){
        guard let content = self.content else { return }
        self.contentTitleTextView.text = content.contentTitle
        self.contentTitleTextView.textColor = .yagiGrayDeep
        self.writingView.text = content.contentText
        self.writingView.textColor = .yagiGrayDeep
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd E"
            let languge = Locale.preferredLanguages.first ?? "en-US"
            dateFormatter.locale = Locale(identifier: languge)
            return dateFormatter
        }()
        self.datePicker.setDate(dateFormatter.date(from: content.ContentDate) ?? Date(), animated: true)
    }
    
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

//MARK: - ScrollViewDelegate
extension WritingViewController: UIScrollViewDelegate {}

//MARK: - TextViewDelegate
extension WritingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == UIColor.placeholderText else{ return }
        
        textView.text = ""
        textView.textColor = .yagiGrayDeep
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textView == self.contentTitleTextView ? "제목을 입력하세요" : "내용을 입력하세요"
            textView.textColor = .placeholderText
            self.saveButton.isEnabled = false
            
            return
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.saveButton.isEnabled = false
            return
        }
        
        switch textView {
        case contentTitleTextView:
            if textView.text != "제목을 입력하세요" { self.contentTitle = textView.text }
            if writingView.text == "내용을 입력하세요" { return }
        default:
            if textView.text != "내용을 입력하세요" { self.contentText = textView.text }
            if contentTitleTextView.text == "제목을 입력하세요" { return }
        }
        
        self.saveButton.isEnabled = true
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
