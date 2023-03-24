//
//  UserDafaultStandardWrapper.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/21.
//

import Foundation

@propertyWrapper
struct UserDefaultStandardWrapper<T> {
    private let userDefaultKey: String = "Yagi_Standard"
    private let dictionaryKey: String
    private let defaultValue: T?
    
    init(dictionaryKey: String, defaultValue: T?) {
        self.dictionaryKey = dictionaryKey
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            guard let userData = UserDefaults.standard.object(forKey: userDefaultKey) as? Dictionary<String, Any>,
                  let data = userData[dictionaryKey] as? T
            else { return nil }
            
            return data
        }
        
        set {
            guard let data = newValue else { return }
            let userData: Dictionary<String, Any> = [ dictionaryKey : data ]
            
            UserDefaults.standard.set(userData, forKey: userDefaultKey)
        }
    }
}
