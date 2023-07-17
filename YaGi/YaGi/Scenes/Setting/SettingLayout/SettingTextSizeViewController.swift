//
//  SettingTextSizeViewController.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/07/16.
//

import UIKit

import SnapKit

class SettingTextSizeViewController: UIViewController {
    
    //MARK: - View
    private var stepper = CSStepper(value: UserDefaultsManager.layout?.textSize ?? 20)
    private var detailView = CSDetailView()
    private var doneButton = UIButton()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        layout()
    }
    
    //MARK: - Function
    @objc func changeTextSize(sender: CSStepper) {
        let size = CGFloat(sender.value)
        
        detailView.contentTitle.font = detailView.contentTitle.font.withSize(size)
        detailView.contentLabel.font = detailView.contentLabel.font.withSize(size)
    }
    
    @objc func didTapDoneButton() {
        let layout = SettingLayoutModel(textSize: stepper.value)
        UserDefaultsManager.layout = layout
        self.dismiss(animated: true)
    }
}

//MARK: - Configure
private extension SettingTextSizeViewController {
    
    func configureView() {
        
        self.view.backgroundColor = .yagiWhite
        
        detailView.contentTitle.text = "야기"
        detailView.contentLabel.text =
"""
나만의 이야기로
책을 만드는
간단한 글 작 성 서비스

글자 크기 조정을 통해
조금 더 편하게 글을 작성해 보세요.
"""
        doneButton.tintColor = .yagiHighlight
        doneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        stepper.addTarget(self, action: #selector(changeTextSize), for: .valueChanged)
        
    }
    
    func layout() {
        
        [
            doneButton,
            detailView,
            stepper
        ]
            .forEach { self.view.addSubview($0) }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(doneButton).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(stepper)
        }
        
        stepper.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
