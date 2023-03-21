//
//  BookStore.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/19.
//

import CoreData

public protocol BookStore {
    func fetch(at: Int) -> Book?
    func fetchAll() -> [Book]?
    func create(title: String, date: String)
}
