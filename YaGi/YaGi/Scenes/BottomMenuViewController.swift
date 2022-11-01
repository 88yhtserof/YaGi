//
//  BottomMenuViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/27.
//

import UIKit

class BottomMenuViewController: UIViewController {
    
    private lazy var sheetView: UIView = {
        var view = UIView()
        
        view.backgroundColor = .yagiWhite
        view.roundCorner(round: 20, [.topLeft, .topRight])
        
        return view
    }()
    
    private lazy var buttonStack: UIStackView = {
        var stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        stackView.alignment = .center
        
        [firMenuButton, secMenuButton, thrMenuButton, fthMenuButton].forEach {
            stackView.addArrangedSubview( $0 )
        }
        
        return stackView
    }()
    
    private lazy var firMenuButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("첫 번째 버튼")
        
        attributedTitle.font = .maruburi(ofSize: 20, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.yagiGrayDeep
        
        configuration.attributedTitle = attributedTitle
        
        button.configuration = configuration
        
        return button
    }()
    
    private lazy var secMenuButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("두 번째 버튼")
        
        attributedTitle.font = .maruburi(ofSize: 20, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.yagiGrayDeep
        
        configuration.attributedTitle = attributedTitle
        
        button.configuration = configuration
        
        return button
    }()
    
    private lazy var thrMenuButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("세 번째 버튼")
        
        attributedTitle.font = .maruburi(ofSize: 20, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.yagiGrayDeep
        
        configuration.attributedTitle = attributedTitle
        
        button.configuration = configuration
        
        return button
    }()
    
    private lazy var fthMenuButton: UIButton = {
        var button = UIButton()
        var configuration = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("네 번째 버튼")
        
        attributedTitle.font = .maruburi(ofSize: 20, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.yagiGrayDeep
        
        configuration.attributedTitle = attributedTitle
        
        button.configuration = configuration
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
}

private extension BottomMenuViewController {
    func configureView() {
        
        view.addSubview( sheetView )
        [buttonStack].forEach { sheetView.addSubview( $0 ) }
        
        sheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview()
        }
    }
}
