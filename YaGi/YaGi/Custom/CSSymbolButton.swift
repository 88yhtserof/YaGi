//
//  CSSymbolButton.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/07/15.
//

import UIKit

class CSSymbolButton: UIButton {
    
    //MARK: - init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, symbol: String) {
        super.init(frame: .zero)
        configure(title: title, symbol: symbol)
    }
    
    convenience init(title: String, symbol: String, action: () -> UIAction ){
        self.init(title: title, symbol: symbol)
        
        self.addAction(action(), for: .touchUpInside)
    }
    
    //MARK: - Configure
    func configure(title: String, symbol: String) {
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font : UIFont(name: "MaruBuri-Regular", size: 20) ?? UIFont()]
        )
        let attribitedTitle = AttributedString(title, attributes: attributes)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attribitedTitle
        configuration.baseForegroundColor = .yagiGrayDeep
        configuration.image = UIImage(systemName: symbol)
        configuration.imagePadding = 10.0
        
        self.configuration = configuration
    }
}
