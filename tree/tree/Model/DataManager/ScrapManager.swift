//
//  ScrapManager.swift
//  tree
//
//  Created by Hyeontae on 03/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class ScrapManager {
    static var managedContext: NSManagedObjectContext = {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return NSManagedObjectContext()
        }
        let managedContext: NSManagedObjectContext =
            appDelegate.persistentContainer.viewContext
        
        return managedContext
    }()

    static func scrapArticle(
        article: Article,
        category: ArticleCategory,
        imageData: Data?
    ) -> Void {
        guard let entity =
            NSEntityDescription.entity(forEntityName: "ScrappedArticle", in: managedContext) else {
                return
        }
        let newArticle = ScrappedArticle(entity: entity, insertInto: managedContext)
        newArticle.setValues(
            newArticle,
            articleData: article,
            categoryEnum: category,
            imageData: imageData
        )
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func fetchArticles() -> [ScrappedArticle] {
        let request: NSFetchRequest<ScrappedArticle> = ScrappedArticle.fetchRequest()
        let sortDescriptor: NSSortDescriptor =
            NSSortDescriptor(
                key: #keyPath(ScrappedArticle.scrappedDate),
                ascending: false
        )
        request.sortDescriptors = [sortDescriptor]
        var result: [ScrappedArticle] = []
        result = fetchRequest(request)
        return result
    }
    
    static func fetchArticles(_ category: ArticleCategory) -> [ScrappedArticle] {
        var request: NSFetchRequest<ScrappedArticle> = ScrappedArticle.fetchRequest()
        var result: [ScrappedArticle] = []
        request.predicate =
            NSPredicate(
                format: "%K == %@",
                #keyPath(ScrappedArticle.category),
                category.toString()
        )
        result = fetchRequest(request)
        return result
    }
    
    static func unreadArticlesCount() -> Int {
        var result = 0
        let request: NSFetchRequest = NSFetchRequest<NSNumber>(entityName: "ScrappedArticle")
        let predicate = NSPredicate(format: "isRead == %@", NSNumber(value: false))
        request.predicate = predicate
        request.resultType = .countResultType
        do {
            let countResult = try managedContext.fetch(request)
            guard let resultCount = countResult.first?.intValue else {
                return 0
            }
            result = resultCount
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
    
    static func unreadArticlesCount(category: ArticleCategory) -> Int {
        var result = 0
        let request: NSFetchRequest = NSFetchRequest<NSNumber>(entityName: "ScrappedArticle")
        let predicate = NSPredicate(
            format: "isRead == %@ AND %K == %@",
            NSNumber(value: false),
            #keyPath(ScrappedArticle.category),
            category.toString()
        )
        request.predicate = predicate
        request.resultType = .countResultType
        do {
            let countResult = try managedContext.fetch(request)
            guard let resultCount = countResult.first?.intValue else {
                return 0
            }
            result = resultCount
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
    
    static func removeAllScrappedArticle() {
        let request: NSFetchRequest<ScrappedArticle> = ScrappedArticle.fetchRequest()
        var results: [ScrappedArticle] = []
        do {
            results = try managedContext.fetch(request)
            for item in results {
                managedContext.delete(item)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print("all data is Removed")
    }
    
    static func fetchRequest(_ request: NSFetchRequest<ScrappedArticle>) -> [ScrappedArticle] {
        var result: [ScrappedArticle] = []
        do {
            result = try managedContext.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
}

private extension NSManagedObject {
    func setValue(_ value: Any?, forKey property: ScrappedArticleProperty) {
        self.setValue(value, forKeyPath: "\(property)")
    }
    
    func setCategory(_ category: ArticleCategory) {
        self.setValue(category.toString(), forKey: .category)
    }
    
    func setValues(
        _ newArticle: ScrappedArticle,
        articleData: Article,
        categoryEnum: ArticleCategory,
        imageData: Data?
    ) {
        if let imageData: Data = imageData {
            newArticle.setValue(imageData, forKey: .image)
        }
        newArticle.setCategory(categoryEnum)
        newArticle.setValue(articleData.lang, forKey: .language)
        newArticle.setValue(articleData.author?[0].name ?? "", forKey: .articleAuthor)
        newArticle.setValue(articleData.date, forKey: .articleDate)
        newArticle.setValue(articleData.title, forKey: .articleTitle)
        newArticle.setValue(NSDate(), forKey: .scrappedDate)
        newArticle.setValue(false, forKey: .isRead)
        newArticle.setValue(articleData.uri, forKey: .articleUri)
        newArticle.setValue(articleData.source.title, forKey: .company)
        newArticle.setValue(articleData.body, forKey: .articleDescription)
    }
}
