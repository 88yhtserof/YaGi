//
//  ContentModel.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/06.
//

import Foundation

struct ContentModel: Codable {
    let contentIndex: Int
    let contentTitle: String
    let ContentDate: String
    let contentText: String
    var bookmark: Bool
}
