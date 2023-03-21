//
//  ContentRepository.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/19.
//

import UIKit
import CoreData

class ChapterRepository: ChapterStore {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetch(at index: Int) -> Chapter? {
        
        guard let chapters = fetchAll() else { return nil }
        let chapter = chapters[index]
        
        return chapter
    }
    
    func fetchAll() -> [Chapter]? {
        
        do {
            let request = Chapter.fetchRequest()
            let chapters = try self.context.fetch(request)
            
            return chapters
        }
        catch {
            self.context.rollback()
            print("Failed to fetch request")
            
            return nil
        }
    }
    
    func create(heading: String, content: String, date: String, bookmark: Bool) {
        
        let chapter = Chapter(context: self.context)
        chapter.heading = heading
        chapter.content = content
        chapter.date = date
        chapter.bookmark = bookmark
        
        do {
            try self.context.save()
        }
        catch {
            context.rollback()
            print("Failed to create a content")
        }
    }
    
    func remove(_ chapter: Chapter) {
        
        do {
            self.context.delete(chapter)
            try self.context.save()
        }
        catch {
            context.rollback()
            print("Failed to create a content")
        }
    }
    
    func update(_ newChapter: Chapter) {
        
        do {
            try self.context.save()
        }
        catch {
            context.rollback()
            print("Failed to create a content")
        }
    }
}
