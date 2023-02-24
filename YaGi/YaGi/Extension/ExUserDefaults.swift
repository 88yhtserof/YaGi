//
//  ExUserDefaults.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/24.
//

import Foundation

extension UserDefaults {
    func hasValue(forKey key: String) -> Bool {
        return nil != UserDefaults.standard.object(forKey: key)
    }
}
