//
//  WebExtracted+CoreDataProperties.swift
//  
//
//  Created by Hyeontae on 13/03/2019.
//
//

import Foundation
import CoreData


extension WebExtracted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WebExtracted> {
        return NSFetchRequest<WebExtracted>(entityName: "WebExtracted")
    }

    @NSManaged public var contents: String?
    @NSManaged public var webURL: String?
    @NSManaged public var base: ArticleBase?

}
