//
//  SettingLayoutModel.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/07/17.
//

import Foundation

struct SettingLayoutModel: Codable {
    let textSize: Int
    
    init(textSize:Int = 20) {
        self.textSize = textSize
    }
}
