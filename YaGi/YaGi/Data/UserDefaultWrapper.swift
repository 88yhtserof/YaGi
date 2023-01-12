//
//  UserDefaultWrapper.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/12.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?
    
    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            if let encodedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(T.self, from: encodedData) {
                    return decodedData
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encodedData, forKey: key)
            }
        }
    }
}
