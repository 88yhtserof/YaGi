//
//  ChapterStore.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/19.
//

import CoreData

public protocol ChapterStore {
    func fetch(at: Int) -> Chapter?
    func fetchAll() -> [Chapter]?
    func create(heading: String, content: String, date: String, bookmark: Bool)
    func remove(_ chapter: Chapter)
    func update(_ chapter: Chapter, heading: String, content: String, date: String, bookmark: Bool)
}
