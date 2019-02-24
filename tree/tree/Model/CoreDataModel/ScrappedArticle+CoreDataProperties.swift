//
//  ScrappedArticle+CoreDataProperties.swift
//  tree
//
//  Created by Hyeontae on 21/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//
//

import Foundation
import CoreData


extension ScrappedArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScrappedArticle> {
        return NSFetchRequest<ScrappedArticle>(entityName: "ScrappedArticle")
    }

    @NSManaged public var articleType: String?
    @NSManaged public var articleAuthor: String?
    @NSManaged public var articleDate: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var articleTitle: String?
    @NSManaged public var articleUri: String?
    @NSManaged public var articleURL: String?
    @NSManaged public var category: String?
    @NSManaged public var company: String?
    @NSManaged public var articleData: NSData?
    @NSManaged public var isRead: Bool
    @NSManaged public var language: String?
    @NSManaged public var scrappedDate: NSDate?

}
