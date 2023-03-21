//
//  DraftStore.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/21.
//

import CoreData

public protocol DraftStore {
    func fetch(at: Int) -> Draft?
    func fetchAll() -> [Draft]?
    func create(heading: String, content: String, date: String)
    func remove(_ draft: Draft)
    func update(_ draft: Draft, heading: String, content: String, date: String)
}
