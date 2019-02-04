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
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testArticle = Article.init(
            uri: "1",
            lang: "en",
            date: "2019-2-3",
            time: "00:00",
            sim: 02.07,
            url: "hello.world",
            title: "one",
            body: "test\nbody",
            source: Source.init(uri: "1", dataType: "2", title: "3"),
            author: nil,
            image: nil
        )
        
//        ScrapManager.scrapArticle(article: testArticle)
        fetchData()
    }
    
    private func saveData() {
        let entity = NSEntityDescription.entity(forEntityName: "ScrappedArticle", in: managedContext)!
        let article = ScrappedArticle(entity: entity, insertInto: managedContext)
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
    }
    
    private func deleteAll() {
        
    }
}
