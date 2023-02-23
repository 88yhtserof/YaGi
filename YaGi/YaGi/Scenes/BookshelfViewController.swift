//
//  BookshelfViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/20.
//

import UIKit
import PhotosUI

class BookshelfViewController: UIViewController {
    //MARK: - Properties
    private let indexOfCurrentBook: Int = 0
    private var selection: PHPickerResult?
    
    //MARK: - View
    private lazy var settingBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        
        let action = UIAction {_ in
            let menuViewController = SettingViewController()
            self.navigationController?.pushViewController(menuViewController, animated: true)
        }
        
        item.primaryAction = action
        item.image = UIImage(systemName: "ellipsis")
        item.tintColor = .yagiGray
        
        return item
    }()
    
    private lazy var editBookcoverBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        
        let action = UIAction { _ in
            self.presentPicker()
        }
        
        item.primaryAction = action
        item.image = UIImage(systemName: "photo.on.rectangle.angled")
        item.tintColor = .yagiGray
        
        return item
    }()
    
    private lazy var bookcoverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Yagi_bookshelf_medium_480")
        imageView.layer.shadowColor = UIColor.yagiWhihtDeep.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowRadius = 10.0
        
        return imageView
    }()
    
    private lazy var bookTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "책 제목 Label"
        label.font = .maruburi(ofSize: 20, weight: .semiBold)
        label.textColor = .yagiGrayDeep
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var bookcoverDesignImageView: UIImageView = {
        let imageView = UIImageView()
        
        // TODO: - 이미지 확인용이므로 수정 필요
        let image = UIImage(named: "Yagi_logo_120")
        //imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageView
    }()
    
    private lazy var bottomView: UIView = {
        let view  = UIView()
        
        view.backgroundColor = .yagiHighlight.withAlphaComponent(0.5)
        view.roundCorner(round: 50, [.topLeft, .topRight])
        view.layer.shadowColor = UIColor.yagiWhihtDeep.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -8)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 3.0
        
        return view
    }()
    
    private lazy var presentContentsButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "book.closed.circle.fill")
        
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 35.0)
        configuration.preferredSymbolConfigurationForImage = imageConfiguration
        configuration.baseForegroundColor = .yagiWhite
        configuration.imagePadding = 20.0
        
        let acton = UIAction { _ in
            let contentsVC = MainTabBarController()
            contentsVC.modalTransitionStyle = .coverVertical
            contentsVC.modalPresentationStyle = .fullScreen
            
            self.present(contentsVC, animated: true)
        }
        let button = UIButton(configuration: configuration, primaryAction: acton)
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureData()
    }
}

//MARK: - Configure
private extension BookshelfViewController {
    func configureData() {
        guard let books = UserDefaultsManager.books else { return }
        
        if let image = UserDefaultsManager.bookcoverDesignImage {
            displayImage(image)
        } else {
            displayEmptyImage()
        }
        
        let title = books[indexOfCurrentBook].title
        self.bookTitleLabel.text = title
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .yagiGray
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem = editBookcoverBarItem
        self.navigationItem.rightBarButtonItem = settingBarItem
    }
    
    func configureView() {
        self.view.backgroundColor = .yagiWhite
        
        [
            bookcoverDesignImageView,
            bookTitleLabel
        ]
            .forEach{ bookcoverImageView.addSubview($0) }
        
        [
            presentContentsButton
        ]
            .forEach{ bottomView.addSubview($0) }
        
        [
            bookcoverImageView,
            bottomView
        ]
            .forEach{ view.addSubview($0) }
        
        let bottomViewHeight = view.frame.height / 6
        
        bookcoverImageView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.bottom.equalToSuperview().inset(bottomViewHeight * 2).priority(.high)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        bookTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalToSuperview().inset(100)
        }
        
        bookcoverDesignImageView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
            make.top.equalTo(bookTitleLabel.snp.bottom)
            
        }
        
        bottomView.snp.makeConstraints{ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(bottomViewHeight).priority(.high)
        }
        
        presentContentsButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
}

//MARK: - PHPicker
private extension BookshelfViewController {
    func presentPicker() {
        var configuaration = PHPickerConfiguration()
        
        configuaration.filter = PHPickerFilter.images
        configuaration.preferredAssetRepresentationMode = .current
        configuaration.selectionLimit = 1
        
        let pickerVC = PHPickerViewController(configuration: configuaration)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    func loadImage(){
        guard let selection = self.selection else { return }
        
        let itemProvider = selection.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self?.handleCompletion(object: image, error: error)
                }
            }
        }
    }
    
    func handleCompletion(object: UIImage?, error: Error? = nil){
        if let image = object {
            self.displayImage(image)
        } else if let error = error {
            print("Couldn't display the image with error \(error)")
            displayErrorImage()
        }
    }
    
    func displayImage(_ image: UIImage?){
        bookcoverDesignImageView.image = image
        UserDefaultsManager.bookcoverDesignImage = image
    }
    
    func displayEmptyImage(){
        displayImage(nil)
    }
    
    func displayErrorImage(){
        let errorImage = UIImage(systemName: "photo.circle")
        errorImage?.withTintColor(.yagiGray)
        
        displayImage(errorImage)
    }
}

extension BookshelfViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        selection = results.first
        
        if selection == nil {
            displayEmptyImage()
        } else {
            loadImage()
        }
    }
}
