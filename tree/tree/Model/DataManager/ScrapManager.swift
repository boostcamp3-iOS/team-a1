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
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.scrapViewController?.scrappedArticles = ScrapManager.fetchArticles()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func scrapArticle(webArticle: WebViewArticle){
        guard let entity =
            NSEntityDescription.entity(forEntityName: "ScrappedArticle", in: managedContext) else {
            return
        }
        let newWebViewArticle = ScrappedArticle(entity: entity, insertInto: managedContext)
        newWebViewArticle.setValues(newWebViewArticle, articleData: webArticle)
        do {
            try managedContext.save()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.scrapViewController?.scrappedArticles = ScrapManager.fetchArticles()
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
                category.stringValue
        )
        result = fetchRequest(request)
        return result
    }
    
    static func countArticle(_ isRead: Bool?) -> Int {
        if let isRead = isRead {
            return countArticleFetch(NSPredicate(format: "isRead == %@", NSNumber(value: isRead)))
        }
        return countArticleFetch(nil)
    }
    
    static func countArticle(category: ArticleCategory, _ isRead: Bool?) -> Int {
        var predicate: NSPredicate
        if let isRead = isRead {
            predicate = NSPredicate(
                format: "isRead == %@ AND %K == %@",
                NSNumber(value: isRead),
                #keyPath(ScrappedArticle.category),
                category.stringValue
            )
        } else {
            predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ScrappedArticle.category),
                category.stringValue
            )
        }
        return countArticleFetch(predicate)
    }
    
    typealias IsScrappedHandler = (Bool,ScrappedArticle?) -> Void
    static func articleIsScrapped(
        uri articleUri: String,
        completion: @escaping IsScrappedHandler
    ) -> Void {
        let request: NSFetchRequest = ScrappedArticle.fetchRequest()
        request.predicate = NSPredicate(format: "articleUri == %@", articleUri)
        do {
            let result = try managedContext.fetch(request)
            if result.isEmpty {
                completion(false,nil)
            } else {
                completion(true,result.first)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func countArticleFetch(_ predicate: NSPredicate?) -> Int{
        let request: NSFetchRequest = NSFetchRequest<NSNumber>(entityName: "ScrappedArticle")
        request.resultType = .countResultType
        if let predicate = predicate {
            request.predicate = predicate
        }
        do {
            let result = try managedContext.fetch(request)
            guard let resultCount = result.first?.intValue else {
                return 0
            }
            return resultCount
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
    
    static func removeArticle(_ article: ScrappedArticle) {
        managedContext.delete(article)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
        self.setValue(category.stringValue, forKey: .category)
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
        if let authors = articleData.author,
            authors.count > 0 {
            newArticle.setValue(authors.first?.name, forKey: .articleAuthor)
        }
        newArticle.setCategory(categoryEnum)
        newArticle.setValue(articleData.lang, forKey: .language)
        newArticle.setValue(articleData.date, forKey: .articleDate)
        newArticle.setValue(articleData.title, forKey: .articleTitle)
        newArticle.setValue(NSDate(), forKey: .scrappedDate)
        newArticle.setValue(false, forKey: .isRead)
        newArticle.setValue(articleData.uri, forKey: .articleUri)
        newArticle.setValue(articleData.source.title, forKey: .company)
        newArticle.setValue(articleData.body, forKey: .articleDescription)
    }
    
    func setValues(
        _ newWebViewArticle: ScrappedArticle,
        articleData: WebViewArticle
    ) {
        newWebViewArticle.setCategory(.live)
        newWebViewArticle.setValue(NSDate(), forKey: .scrappedDate)
        newWebViewArticle.setValue(articleData.webData as NSData, forKey: .articleWebData)
        newWebViewArticle.setValue(articleData.articleURL, forKey: .articleURL)
        newWebViewArticle.setValue(articleData.press, forKey: .articleAuthor)
        newWebViewArticle.setValue(articleData.title, forKey: .articleTitle)
    }
}
