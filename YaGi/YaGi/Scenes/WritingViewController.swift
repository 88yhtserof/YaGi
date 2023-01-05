//
//  WritingViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/08.
//

import UIKit
import SnapKit

class WritingViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
}

private extension WritingViewController {
    
    func configureView() {
        self.view.backgroundColor = .yagiWhite
        
        [
            cancelButton
        ].forEach { view.addSubview($0) }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
        }
    }
}
