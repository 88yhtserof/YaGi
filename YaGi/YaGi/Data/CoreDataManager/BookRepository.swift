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
}
