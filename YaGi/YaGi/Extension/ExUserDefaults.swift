//
//  ExUserDefaults.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/21.
//

import UIKit

extension UserDefaults {
    func hasValue(forKey key: String) -> Bool {
        return nil != UserDefaults.standard.object(forKey: key)
    }
}
