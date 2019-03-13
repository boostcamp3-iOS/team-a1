//
//  Web+CoreDataProperties.swift
//  
//
//  Created by Hyeontae on 13/03/2019.
//
//

import Foundation
import CoreData


extension Web {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Web> {
        return NSFetchRequest<Web>(entityName: "Web")
    }

    @NSManaged public var webData: NSData?
    @NSManaged public var webURL: String?
    @NSManaged public var base: ArticleBase?

}
