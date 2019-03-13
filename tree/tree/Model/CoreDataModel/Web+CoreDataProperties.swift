//
//  Web+CoreDataProperties.swift
//  tree
//
//  Created by Hyeontae on 13/03/2019.
//  Copyright © 2019 gardener. All rights reserved.
//
//

import Foundation
import CoreData


extension Web {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Web> {
        return NSFetchRequest<Web>(entityName: "Web")
    }

    @NSManaged public var webData: NSData
    @NSManaged public var webURL: String
    @NSManaged public var base: ArticleBase

}
