//
//  Book+CoreDataProperties.swift
//  YaGi
//
//  Created by 임윤휘 on 2023/03/21.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var date: String?
    @NSManaged public var title: String?
    @NSManaged public var contents: NSOrderedSet?
    @NSManaged public var drafts: NSOrderedSet?

}

// MARK: Generated accessors for contents
extension Book {

    @objc(insertObject:inContentsAtIndex:)
    @NSManaged public func insertIntoContents(_ value: Chapter, at idx: Int)

    @objc(removeObjectFromContentsAtIndex:)
    @NSManaged public func removeFromContents(at idx: Int)

    @objc(insertContents:atIndexes:)
    @NSManaged public func insertIntoContents(_ values: [Chapter], at indexes: NSIndexSet)

    @objc(removeContentsAtIndexes:)
    @NSManaged public func removeFromContents(at indexes: NSIndexSet)

    @objc(replaceObjectInContentsAtIndex:withObject:)
    @NSManaged public func replaceContents(at idx: Int, with value: Chapter)

    @objc(replaceContentsAtIndexes:withContents:)
    @NSManaged public func replaceContents(at indexes: NSIndexSet, with values: [Chapter])

    @objc(addContentsObject:)
    @NSManaged public func addToContents(_ value: Chapter)

    @objc(removeContentsObject:)
    @NSManaged public func removeFromContents(_ value: Chapter)

    @objc(addContents:)
    @NSManaged public func addToContents(_ values: NSOrderedSet)

    @objc(removeContents:)
    @NSManaged public func removeFromContents(_ values: NSOrderedSet)

}

// MARK: Generated accessors for drafts
extension Book {

    @objc(insertObject:inDraftsAtIndex:)
    @NSManaged public func insertIntoDrafts(_ value: Draft, at idx: Int)

    @objc(removeObjectFromDraftsAtIndex:)
    @NSManaged public func removeFromDrafts(at idx: Int)

    @objc(insertDrafts:atIndexes:)
    @NSManaged public func insertIntoDrafts(_ values: [Draft], at indexes: NSIndexSet)

    @objc(removeDraftsAtIndexes:)
    @NSManaged public func removeFromDrafts(at indexes: NSIndexSet)

    @objc(replaceObjectInDraftsAtIndex:withObject:)
    @NSManaged public func replaceDrafts(at idx: Int, with value: Draft)

    @objc(replaceDraftsAtIndexes:withDrafts:)
    @NSManaged public func replaceDrafts(at indexes: NSIndexSet, with values: [Draft])

    @objc(addDraftsObject:)
    @NSManaged public func addToDrafts(_ value: Draft)

    @objc(removeDraftsObject:)
    @NSManaged public func removeFromDrafts(_ value: Draft)

    @objc(addDrafts:)
    @NSManaged public func addToDrafts(_ values: NSOrderedSet)

    @objc(removeDrafts:)
    @NSManaged public func removeFromDrafts(_ values: NSOrderedSet)

}

extension Book : Identifiable {

}
