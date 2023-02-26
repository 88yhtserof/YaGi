//
//  ContentsCollectionItemModel.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/26.
//

import Foundation

struct ContentsCollectionItemModel {
    let sectionType: SectionType
    var items: [Any]?
    
    enum SectionType {
        case draft
        case contents
    }
}
