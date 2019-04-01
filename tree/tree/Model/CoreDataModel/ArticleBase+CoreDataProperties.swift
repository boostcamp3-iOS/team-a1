//
//  ArticleBase+CoreDataProperties.swift
//  tree
//
//  Created by Hyeontae on 13/03/2019.
//  Copyright © 2019 gardener. All rights reserved.
//
//

import Foundation
import CoreData


extension ArticleBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleBase> {
        return NSFetchRequest<ArticleBase>(entityName: "ArticleBase")
    }

    @NSManaged public var articleType: Int16
    @NSManaged public var author: String?
    @NSManaged public var isRead: Bool
    @NSManaged public var scrappedDate: NSDate
    @NSManaged public var title: String
    @NSManaged public var searched: Search?
    @NSManaged public var web: Web?
    @NSManaged public var webExtracted: WebExtracted?
    
    var articleTypeEnum: ScrappedArticleType {
        if let articleEnum = ScrappedArticleType(rawValue: articleType) {
            return articleEnum
        }
        return .search
    }

}
