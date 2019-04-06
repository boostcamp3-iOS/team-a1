//
//  WebExtracted+CoreDataProperties.swift
//  tree
//
//  Created by Hyeontae on 13/03/2019.
//  Copyright © 2019 gardener. All rights reserved.
//
//

import Foundation
import CoreData


extension WebExtracted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WebExtracted> {
        return NSFetchRequest<WebExtracted>(entityName: "WebExtracted")
    }

    @NSManaged public var contents: String
    @NSManaged public var imageData: NSData?
    @NSManaged public var webURL: String
    @NSManaged public var base: ArticleBase

}
