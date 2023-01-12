//
//  UserDefaultWrapper.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/01/12.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let userDefaultKey: String = "YaGi_UserData"
    private let dictionaryKey: String
    private let defaultValue: T?
    
    init(dictionaryKey: String, defaultValue: T?) {
        self.dictionaryKey = dictionaryKey
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        //UserDafaults에 userDefaultKey를 사용해 Dictionary<String: Any>를 저장한다.
        //사용자 데이터는 이 Dictionary에 dictionaryKey를 사용해 [BookModel]이 Data로 encode되어 저장된다.
        get {
            if let dictionary = UserDefaults.standard.object(forKey: userDefaultKey) as? [String : Any],
               let encodedData = dictionary[dictionaryKey] as? Data {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(T.self, from: encodedData){
                    return decodedData
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encodedNewValue = try? encoder.encode(newValue) {
                let dictionary = [dictionaryKey : encodedNewValue]
                UserDefaults.standard.set(dictionary, forKey: userDefaultKey)
            }
        }
    }
}
