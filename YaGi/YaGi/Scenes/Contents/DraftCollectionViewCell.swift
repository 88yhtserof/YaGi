///
//  DraftCollectionViewCell.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/26.
//

import UIKit

// TODO: - Cell 구성
class DraftCollectionViewCell: UICollectionViewCell {
    private lazy var testLabel: UILabel = {
       let label = UILabel()
        
        label.text = ""
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .yagiGrayLight
        
        self.contentView.addSubview(testLabel)
        
        testLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
    }
    
    func test(_ index: Int){
        testLabel.text = String(index)
    }
}
