//
//  BottomMenuViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/27.
//

import UIKit

//MARK: - Enumertaion
enum BottomMenuButtonNumber: Int {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
}

//MARK: - Class
class BottomMenuViewController: UIViewController {
    //MARK: - Properties
    var numberOfButtons: BottomMenuButtonNumber = .fourth
    var firMenuButtonAction: (() -> Void) = {print("TouchUpInside first")}
    var secMenuButtonAction: (() -> Void) = {print("TouchUpInside second")}
    var thrMenuButtonAction: (() -> Void) = {print("TouchUpInside third")}
    var fthMenuButtonAction: (() -> Void) = {print("TouchUpInside fourth")}
    
    //MARK: - Views
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
        
        var buttons: [UIButton] = []
        
        switch numberOfButtons {
        case .first:
            buttons.append(firMenuButton)
        case .second:
            buttons.append(contentsOf: [firMenuButton, secMenuButton])
        case .third:
            buttons.append(contentsOf: [firMenuButton, secMenuButton, thrMenuButton])
        case .fourth:
            buttons.append(contentsOf: [firMenuButton, secMenuButton, thrMenuButton, fthMenuButton])
        }
        
        buttons.forEach {
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
        button.addAction( UIAction { _ in self.firMenuButtonAction() } , for: .touchUpInside)
        
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
        button.addAction(UIAction { _ in self.secMenuButtonAction() }, for: .touchUpInside)
        
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
        button.addAction( UIAction{ _ in self.thrMenuButtonAction() }, for: .touchUpInside)
        
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
        button.addAction( UIAction{ _ in self.fthMenuButtonAction() }, for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureView()
        configurePresent()
    }
}

//MARK: - Configure
private extension BottomMenuViewController {
    func configureView() {
        view.backgroundColor = .yagiGrayDeep.withAlphaComponent(0.5)
        
        view.addSubview( sheetView )
        [buttonStack].forEach { sheetView.addSubview( $0 ) }
        
        sheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview()
        }
        
        self.view.layoutIfNeeded()
    }
    
    func configurePresent() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.sheetView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(300)
            }
            self?.view.layoutIfNeeded()
        }
    }
    
    
    func configureDismiss(_ completion: @escaping () -> Void ) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.sheetView.snp.remakeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(0)
            }
            self?.view.layoutIfNeeded()
        } completion: { _ in
            print("Dismiss BottomMenu")
            completion()
        }
    }
}

//MARK: - Override
extension BottomMenuViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        configureDismiss {
            self.dismiss(animated: true)
        }
    }
}
