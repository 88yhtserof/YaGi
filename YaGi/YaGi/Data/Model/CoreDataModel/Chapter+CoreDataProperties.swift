//
//  Chapter+CoreDataProperties.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/19.
//
//

import Foundation
import CoreData


extension Chapter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chapter> {
        return NSFetchRequest<Chapter>(entityName: "Chapter")
    }

    @NSManaged public var heading: String?
    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var bookmark: Bool
    @NSManaged public var contents: Book?
    @NSManaged public var drafts: Book?

}

extension Chapter : Identifiable {

}
