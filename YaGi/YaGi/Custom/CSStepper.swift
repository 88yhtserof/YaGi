//
//  CSStepper.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/07/16.
//

import UIKit

import SnapKit

class CSStepper: UIControl {
    
    //MARK: - Properties
    var value:Int = 20 {
        didSet {
            self.resultLabel.text = value.description
            self.sendActions(for: .valueChanged)
        }
    }
    
    //MARK: - View
    private var decresmentButton = UIButton()
    private var incrementButton = UIButton()
    private var resultLabel = UILabel()
    private var stepperStackView = UIStackView()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Fuction
    @objc func valueChaned(_ sender: UIButton) {
        self.value += sender.tag
    }
}

//MARK: - Configure
private extension CSStepper {
    
    func configure() {
        
        self.layer.borderColor = UIColor.yagiHighlightLight.cgColor
        self.layer.borderWidth = 1.0
        
        decresmentButton.tag = -1
        decresmentButton.tintColor = .yagiHighlight
        decresmentButton.setImage(UIImage(systemName: "minus"), for: .normal)
        decresmentButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        
        incrementButton.tag = 1
        incrementButton.tintColor = .yagiHighlight
        incrementButton.setImage(UIImage(systemName: "plus"), for: .normal)
        incrementButton.addTarget(self, action: #selector(valueChaned(_:)), for: .touchUpInside)
        
        resultLabel.text = value.description
        resultLabel.font = .maruburi(ofSize: 20, weight: .regular)
        resultLabel.textColor = .yagiGrayDeep
        
        [
            decresmentButton,
            resultLabel,
            incrementButton
        ]
            .forEach { stepperStackView.addArrangedSubview($0) }
        
        stepperStackView.axis = .horizontal
        stepperStackView.alignment = .center
        stepperStackView.distribution = .equalCentering
    }
    
    func layout() {
        
        self.addSubview(stepperStackView)
        
        stepperStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(50)
        }
    }
}
