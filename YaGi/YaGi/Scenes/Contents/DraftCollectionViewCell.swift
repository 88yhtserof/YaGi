///
//  DraftCollectionViewCell.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/26.
//

import UIKit

// TODO: - Cell 구성
class DraftCollectionViewCell: UICollectionViewCell {
    private lazy var draftImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "doc.text.fill")
        imageView.tintColor = .yagiHighlight.withAlphaComponent(0.6)
        
        return imageView
    }()
    
    private lazy var draftTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "임시저장 글 제목"
        label.font = .maruburi(ofSize: 15, weight: .regular)
        label.textColor = .yagiGrayDeep
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureView()
    }
    
    func configureCellData(draftTitle title: String){
        draftTitleLabel.text = title
    }
}

private extension DraftCollectionViewCell {
    func configureView(){
        contentView.backgroundColor = .yagiGrayLight.withAlphaComponent(0.1)
        
        [
            draftImageView,
            draftTitleLabel
        ]
            .forEach{ contentView.addSubview($0) }
        
        draftImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
            make.width.equalTo(draftImageView.snp.height)
        }
        
        draftTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(draftImageView)
            make.leading.equalTo(draftImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
        }
    }
}
