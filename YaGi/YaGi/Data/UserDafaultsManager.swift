//
//  UserDafaultsManager.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/12.
//

import UIKit

struct UserDefaultsManager {
    @UserDefaultWrapper(dictionaryKey: "Books", defaultValue: nil)
    static var books: [BookModel]?
    
    @UserDefaultBookcoverDesignImageWrapper(dictionaryKey: "Books", indexOfBook: 0, defaultValue: nil)
    static var bookcoverDesignImage: UIImage?
}
