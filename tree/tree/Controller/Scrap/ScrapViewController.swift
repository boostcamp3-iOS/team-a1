//
//  ScrapViewController.swift
//  tree
//
//  Created by Hyeontae on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import CoreData

class ScrapViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return NSManagedObjectContext()
        }
        return appDelegate.persistentContainer.viewContext
    }
//    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        saveData()
        fetchData()
    }
    
    private func saveData() {
        let entity = NSEntityDescription.entity(forEntityName: "ScrappedArticle", in: managedContext)!
        let article = ScrappedArticle(entity: entity, insertInto: managedContext)
//        article.scrappedDate = NSDate()
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchData() {
        let request: NSFetchRequest<ScrappedArticle> = ScrappedArticle.fetchRequest()

        var objs: [ScrappedArticle] = []
        do {
            objs = try managedContext.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(objs.count)
        print(objs[0].scrappedDate)
    }
}
