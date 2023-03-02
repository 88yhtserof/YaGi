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
    private let indexOfCurrentBook: Int = 0
    private var books = UserDefaultsManager.books
    private let contentIndex: Int?
    private let sectionType: ContentsCollectionItemModel.SectionType
    private var isBookmark = false
    
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
    
    init(sectionType: ContentsCollectionItemModel.SectionType, contentIndex: Int?, isEditMode: Bool) {
        self.sectionType = sectionType
        self.contentIndex = contentIndex //수정 시에만 할당
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
    
    private lazy var saveDraftButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "doc.text.fill")
        configuration.baseForegroundColor = .yagiHighlight
        
        let action = UIAction { _ in
            let content = self.createContent(
                title: self.contentTitle,
                text: self.contentText,
                isBookmark: false
            )
            
            self.saveDraftContent(content)
            
            self.dismiss(animated: true)
        }
        
        button.configuration = configuration
        button.addAction(action, for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "checkmark")
        configuration.baseForegroundColor = .yagiHighlight
        
        let action = UIAction { _ in
            let content = self.createContent(
                title: self.contentTitle,
                text: self.contentText,
                isBookmark: self.isBookmark
            )
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
            
            if self.contentTitle != "제목을 입력하세요",
               self.contentText != "내용을 입력하세요" {
                self.saveButton.isEnabled = true
            }
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
        textView.tintColor = .yagiHighlight
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
        textView.tintColor = .yagiHighlight
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
    func createContent(title: String, text: String, isBookmark: Bool) -> ContentModel {
        
        let content = ContentModel(
            contentTitle: title,
            ContentDate: self.contentDate,
            contentText: text,
            bookmark: isBookmark
        )
        
        return content
    }
    
    func saveContent(_ content: ContentModel) {
        guard var books = self.books else { return }
        var book = books[self.indexOfCurrentBook]
        
        if sectionType == .contents
            && isEditMode {
            guard var contents = book.contents,
                  let contentIndex = self.contentIndex else { return }
            contents[contentIndex] = content
            book.contents = contents
        }
        else {
            if sectionType == .draft {
                guard var drafts = book.drafts,
                      let contentIndex = self.contentIndex else { return }
                drafts.remove(at: contentIndex)
                book.drafts = drafts
            }
            
            if book.contents == nil {
                book.contents = Array<ContentModel>()
            }
            book.contents?.append(content)
        }
        
        books[indexOfCurrentBook] = book
        UserDefaultsManager.books = books
    }
    
    func saveDraftContent(_ draftCotent: ContentModel){
        guard var books = self.books else { return }
        var book = books[self.indexOfCurrentBook]
        
        if isEditMode {
            guard var drafts = book.drafts,
                  let contentIndex = self.contentIndex else { return }
            drafts[contentIndex] = draftCotent
            book.drafts = drafts
        } else {
            if book.drafts == nil { book.drafts = Array<ContentModel>() }
            book.drafts?.append(draftCotent)
        }
        
        books[self.indexOfCurrentBook] = book
        UserDefaultsManager.books = books
    }
}

//MARK: - Configure
private extension WritingViewController {
    
    //글 수정 시에만 호출
    func configureData(){
        guard let books = self.books,
              let contentIndex = self.contentIndex else { return }
        
        var contents: [ContentModel]?
        switch sectionType {
        case .draft:
            contents = books[indexOfCurrentBook].drafts
        case .contents:
            contents = books[indexOfCurrentBook].contents
        }
        guard let content = contents?[contentIndex] else { return }
        self.books = books
        self.contentTitle = content.contentTitle
        self.contentText = content.contentText
        self.contentDate = content.ContentDate
        self.isBookmark = content.bookmark
        
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
            saveDraftButton,
            saveButton,
            datePicker,
            contentTitleTextView,
            writingView
        ]
            .forEach { contentView.addSubview($0) }
        
        let inset: Int = 20
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
        
        saveDraftButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton)
            make.trailing.equalTo(saveButton.snp.leading)
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
            self.saveDraftButton.isEnabled = false
            
            return
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.saveButton.isEnabled = false
            self.saveDraftButton.isEnabled = false
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
        self.saveDraftButton.isEnabled = true
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
