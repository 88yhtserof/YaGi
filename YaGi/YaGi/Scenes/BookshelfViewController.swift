//
//  BookshelfViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/20.
//

import UIKit

class BookshelfViewController: UIViewController {
    private lazy var bookcoverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Yagi_bookshelf_480")
        imageView.layer.shadowColor = UIColor.yagiGrayLight.cgColor
        imageView.layer.shadowOffset = CGSize(width: -13, height: 20)
        imageView.layer.shadowOpacity = 0.2
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

private extension BookshelfViewController {
    func configureView() {
        self.view.backgroundColor = .yagiWhite
        
        [
            bookcoverImageView
        ]
            .forEach{ view.addSubview($0) }
        
        bookcoverImageView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
}
