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
            print("Failed to create a chapter")
        }
    }
    
    func remove(_ chapter: Chapter) {
        
        do {
            self.context.delete(chapter)
            try self.context.save()
        }
        catch {
            context.rollback()
            print("Failed to remove the chapter")
        }
    }
    
    func update(_ chapter: Chapter, heading: String, content: String, date: String, bookmark: Bool) {
        
        chapter.heading = heading
        chapter.content = content
        chapter.date = date
        chapter.bookmark = bookmark
        
        do {
            try self.context.save()
        }
        catch {
            context.rollback()
            print("Failed to update the chapter")
        }
    }
    
    func updateBookmark(_ chapter: Chapter, _ isBookmark: Bool) {
        
        chapter.bookmark = isBookmark
        
        do {
            try self.context.save()
        }
        catch {
            context.rollback()
            print("Failed to update the bookmark of data")
        }
    }
    
    func unbookmarkAll(_ chapters: [Chapter]){
        
        for chapter in chapters {
            chapter.bookmark = false
        }
        
        do {
            try self.context.save()
        }
        catch {
            self.context.rollback()
            print("Failed to unbookmark all chapters")
        }
        
    }
}
