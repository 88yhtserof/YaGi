//
//  BookRepository.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/21.
//

import UIKit
import CoreData

class BookRepository: BookStore {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func hasValue() -> Bool {
        return nil != fetchAll()
    }
    
    func fetch(at index: Int) -> Book? {
        
        guard let books = fetchAll() else { return nil }
        let book = books[index]
        
        return book
    }
    
    func fetchAll() -> [Book]? {
        
        do {
            let request = Book.fetchRequest()
            let books = try self.context.fetch(request)
            
            return books
        }
        catch {
            self.context.rollback()
            print("Failed to fetch the books")
            
            return nil
        }
    }
    
    func create(title: String, date: String) {
        
        let book = Book(context: self.context)
        book.title = title
        book.date = date
        
        do {
            try self.context.save()
        }
        catch {
            self.context.rollback()
            print("Failed to create a book")
        }
    }
    
    func moveDatafromUserDefaults(){
        guard let userData = UserDefaultsManager.books?.first else { return }
        
        let book = Book(context: self.context)
        book.title = userData.title
        book.date = userData.date
        
        if let contents = userData.contents {
            let chapters = contents.map({ data in
                let chapter = Chapter(context: self.context)
                chapter.heading = data.contentTitle
                chapter.content = data.contentText
                chapter.date = data.ContentDate
                chapter.bookmark = data.bookmark
                
                return chapter
            })
            book.insertIntoContents(chapters, at: NSIndexSet(index: 0))
        }
        
        if let drafts = userData.drafts {
            let drafts = drafts.map { data in
                let draft = Draft(context: self.context)
                draft.heading = data.contentTitle
                draft.content = data.contentText
                draft.date = data.ContentDate
                
                return draft
            }
            book.insertIntoDrafts(drafts, at: NSIndexSet(index: 0))
        }
        
        do {
            try self.context.save()
        }
        catch {
            print("Failed to move the Data from UserDefaults")
        }
    }
}
