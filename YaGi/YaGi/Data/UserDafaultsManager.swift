//
//  UserDafaultsManager.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/12.
//

import Foundation

struct UserDefaultsManager {
    @UserDefaultWrapper(dictionaryKey: "Books", defaultValue: nil)
    static var books: [BookModel]?
}
