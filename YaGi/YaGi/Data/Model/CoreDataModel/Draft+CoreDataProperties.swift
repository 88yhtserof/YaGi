//
//  Draft+CoreDataProperties.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/21.
//
//

import Foundation
import CoreData


extension Draft {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Draft> {
        return NSFetchRequest<Draft>(entityName: "Draft")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var heading: String?
    @NSManaged public var book: Book?

}

extension Draft : Identifiable {

}
