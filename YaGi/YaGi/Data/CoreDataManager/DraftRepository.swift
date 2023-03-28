//
//  DraftRepository.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/21.
//

import CoreData
import UIKit

class DraftRepository: DraftStore {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetch(at index: Int) -> Draft? {
        
        guard let drafts = fetchAll() else { return nil }
        let draft = drafts[index]
        
        return draft
    }
    
    func fetchAll() -> [Draft]? {
        
        do {
            let request = Draft.fetchRequest()
            let drafts = try self.context.fetch(request)
            
            return drafts
        }
        catch {
            self.context.rollback()
            print("Failed to fetch request")
            
            return nil
        }
    }
    
    func create(heading: String, content: String, date: String) {
        
        let draft = Draft(context: self.context)
        draft.heading = heading
        draft.content = content
        draft.date = date
        
        do {
            try self.context.save()
        }
        catch {
            self.context.rollback()
            print("Failed to create a draft")
        }
        
    }
    
    func remove(_ draft: Draft) {
        
        do {
            self.context.delete(draft)
            try self.context.save()
        }
        catch {
            self.context.rollback()
            print("Failed to delete the draft")
        }
    }
    
    func update(_ draft: Draft, heading: String, content: String, date: String) {
        
        draft.heading = heading
        draft.content = content
        draft.date = date
        
        do {
            try self.context.save()
        }
        catch {
            self.context.rollback()
            print("Failed to update the draft")
        }
    }
}
