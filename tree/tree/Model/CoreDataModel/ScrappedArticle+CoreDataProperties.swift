//
//  ScrappedArticle+CoreDataProperties.swift
//  
//
//  Created by Hyeontae on 30/01/2019.
//
//

import Foundation
import CoreData

extension ScrappedArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScrappedArticle> {
        return NSFetchRequest<ScrappedArticle>(entityName: "ScrappedArticle")
    }

    @NSManaged public var articleAuthor: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var company: String?
    @NSManaged public var articleDate: String?
    @NSManaged public var image: NSData?
    @NSManaged public var isRead: Bool
    @NSManaged public var language: String?
    @NSManaged public var scrappedDate: NSDate?
    @NSManaged public var articleTitle: String?
    @NSManaged public var articleUri: String?
    @NSManaged public var category: String?
    @NSManaged public var articleHtmlData: NSData?
    @NSManaged public var articleURL: String?
}
