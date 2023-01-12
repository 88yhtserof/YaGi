//
//  UserDafaultsManager.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/12.
//

import Foundation

struct UserDefaultsManager {
    @UserDefaultWrapper(key: "YaGi_UserData", defaultValue: nil)
    static var books: [BookModel]?
}
