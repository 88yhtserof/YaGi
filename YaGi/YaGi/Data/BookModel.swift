//
//  BookModel.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/08.
//

import Foundation

struct BookModel: Codable {
    let date: String
    let title: String
    var contents: [ContentModel]?
}
