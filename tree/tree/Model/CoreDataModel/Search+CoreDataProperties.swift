//
//  Search+CoreDataProperties.swift
//  tree
//
//  Created by Hyeontae on 29/03/2019.
//  Copyright © 2019 gardener. All rights reserved.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var articleDescription: String
    @NSManaged public var imageData: NSData?
    @NSManaged public var webURI: String
    @NSManaged public var articleDate: String
    @NSManaged public var company: String
    @NSManaged public var base: ArticleBase

}
