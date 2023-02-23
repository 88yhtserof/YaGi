//
//  UserDefaultBookcoverDesignImageWrapper.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/02/23.
//

import Foundation
import UIKit

@propertyWrapper
struct UserDefaultBookcoverDesignImageWrapper {
    private let userDefaultKey: String = "YaGi_UserData"
    private let dictionaryKey: String
    private let indexOfBook: Int
    private let defaultValue: UIImage?
    
    init(dictionaryKey: String, indexOfBook: Int, defaultValue: UIImage?) {
        self.dictionaryKey = dictionaryKey
        self.indexOfBook = indexOfBook
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: UIImage? {
        get {
            ///JPEG Data 타입에서 UIImage로 디코딩
            guard let books = UserDefaultsManager.books,
                  let encodedImage = books[indexOfBook].bookcoverDesignImage,
                  let decodedImage = UIImage(data: encodedImage) else { return nil }
            
            return decodedImage
        }
        set {
            ///사진 JPEG Data 타입으로 인코딩
            let handledImage: Data?
            
            if let image = newValue {
                handledImage = image.jpegData(compressionQuality: 1.0)
            } else {
                handledImage = nil
            }
            guard var books = UserDefaultsManager.books else { return }
            books[indexOfBook].bookcoverDesignImage = handledImage
            UserDefaultsManager.books = books
        }
    }
    
}
