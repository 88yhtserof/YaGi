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
        guard let books = fetchAll() else { return false }
        return !books.isEmpty
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
            for data in contents {
                ChapterRepository().create(
                    heading: data.contentTitle,
                    content: data.contentText,
                    date: data.ContentDate,
                    bookmark: data.bookmark
                )
            }
        }
        
        if let drafts = userData.drafts {
            for data in drafts {
                DraftRepository().create(
                    heading: data.contentTitle,
                    content: data.contentText,
                    date: data.ContentDate
                )
            }
        }
        
        do {
            try self.context.save()
        }
        catch {
            print("Failed to move the Data from UserDefaults")
            return
        }
        
        //기존 UserDefaults 데이터 삭제
        UserDefaults.standard.removeObject(forKey: "YaGi_UserData")
        //데이터 이동 여부 저장
        UserDefaultsManager.isImplovedData = true
    }
}
