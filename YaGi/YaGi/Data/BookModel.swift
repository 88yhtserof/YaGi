//
//  BookModel.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/08.
//

import Foundation

struct BookModel: Codable {
    let title: String
    var contents: [ContentModel]?
}
