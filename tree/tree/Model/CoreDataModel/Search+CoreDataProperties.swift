//
//  Search+CoreDataProperties.swift
//  
//
//  Created by Hyeontae on 13/03/2019.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var webURI: String?
    @NSManaged public var base: ArticleBase?

}
