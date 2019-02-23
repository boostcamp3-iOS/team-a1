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
import NetworkFetcher

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
        _ type: ScrappedArticleType,
        articleStruct: Any
    ) {
        guard let entity =
            NSEntityDescription.entity(forEntityName: "ScrappedArticle", in: managedContext) else {
                return
        }
        let newArticle = ScrappedArticle(entity: entity, insertInto: managedContext)
        switch type {
        case .search:
            guard let articleStruct = articleStruct as? SearchedArticleStruct else { return }
            newArticle.setValues(articleStruct)
        case .webExtracted:
            guard let articleStruct = articleStruct as? WebExtractedArticleStruct else { return }
            newArticle.setValues(articleStruct)
        case .web:
            guard let articleStruct = articleStruct as? WebViewArticleStruct else { return }
            newArticle.setValues(articleStruct)
        }
        
        do {
            try managedContext.save()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.scrapViewController?.scrappedArticles = ScrapManager.fetchArticles()
            appDelegate.scrapViewController?.setupScrapBadgeValue()
            
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
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    static func readArticle(
        _ articleType: ScrappedArticleType,
        _ articleIdentifier: String
    ) {
        let request: NSFetchRequest = ScrappedArticle.fetchRequest()
        switch articleType {
        case .search:
            request.predicate = NSPredicate(format: "articleUri == %@", articleIdentifier)
        case .web, .webExtracted:
            request.predicate = NSPredicate(format: "articleURL == %@", articleIdentifier)
        }
        do {
            var result = try managedContext.fetch(request)
            result.first?.isRead = true
            try managedContext.save()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.scrapViewController?.setupScrapBadgeValue()
        } catch {
            print("Could not fetch. \(error)")
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
        } catch {
            print("Could not fetch. \(error)")
        }
        return 0
    }
    
    static func removeArticle(_ article: ScrappedArticle) {
        managedContext.delete(article)
        do {
            try managedContext.save()
        } catch {
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
        } catch {
            print("Could not delete. \(error)")
        }
        print("all data is Removed")
    }
    
    static func fetchRequest(_ request: NSFetchRequest<ScrappedArticle>) -> [ScrappedArticle] {
        var result: [ScrappedArticle] = []
        do {
            result = try managedContext.fetch(request)
        } catch {
            print("Could not fetch. \(error)")
        }
        return result
    }
    
    static func markAllAsRead() {
        let batchUpdate = NSBatchUpdateRequest(entityName: "ScrappedArticle")
        batchUpdate.propertiesToUpdate = [#keyPath(ScrappedArticle.isRead): true]
        batchUpdate.affectedStores = managedContext.persistentStoreCoordinator?.persistentStores
        batchUpdate.resultType = .updatedObjectsCountResultType
        do {
            try managedContext.execute(batchUpdate)
        } catch {
            print("Could not update \(error)")
        }
    }
}

private extension NSManagedObject {
    func setValue(_ value: Any?, forKey property: ScrappedArticleProperty) {
        self.setValue(value, forKeyPath: "\(property)")
    }
    
    func setCategory(_ category: ArticleCategory) {
        self.setValue(category.stringValue, forKey: .category)
    }
    
    func setupBaseProperty(_ type: ScrappedArticleType) {
        self.setValue(type.stringValue, forKey: .articleType)
        self.setValue(NSDate(), forKey: .scrappedDate)
        self.setValue(false, forKey: .isRead)
    }
    
    func setValues(_ articleStruct: Scrappable) {
        switch articleStruct {
        case is WebViewArticleStruct:
            guard let webViewStruct = articleStruct as? WebViewArticleStruct else { return }
            self.setupBaseProperty(.web)
            self.setValue(webViewStruct.title, forKey: .articleTitle)
            self.setValue(webViewStruct.press, forKey: .articleAuthor)
            self.setValue(webViewStruct.webData as NSData, forKey: .articleData)
            self.setValue(webViewStruct.url, forKey: .articleURL)
            self.setCategory(.live)
        case is WebExtractedArticleStruct:
            guard let webExtractedStruct = articleStruct as? WebExtractedArticleStruct else { return }
            self.setupBaseProperty(.webExtracted)
            self.setValue(webExtractedStruct.title, forKey: .articleTitle)
            self.setValue(webExtractedStruct.detail, forKey: .articleDescription)
            self.setValue(webExtractedStruct.press, forKey: .articleAuthor)
            self.setValue(webExtractedStruct.url, forKey: .articleURL)
            self.setValue(webExtractedStruct.imageData, forKey: .articleData)
            self.setCategory(.live)
        case is SearchedArticleStruct:
            self.setupBaseProperty(.search)
            guard
                let searhedArticleStruct = articleStruct as? SearchedArticleStruct,
                let articleData = searhedArticleStruct.articleData as? Article else {
                return
            }
            if let imageData: Data = searhedArticleStruct.imageData {
                self.setValue(imageData, forKey: .articleData)
            }
            if let authors = articleData.author,
                authors.count > 0 {
                self.setValue(authors.first?.name, forKey: .articleAuthor)
            }
            self.setCategory(ArticleCategory(containString: "\(articleData.categories.first)"))
            self.setValue(articleData.lang, forKey: .language)
            self.setValue(articleData.date, forKey: .articleDate)
            self.setValue(articleData.title, forKey: .articleTitle)
            self.setValue(articleData.uri, forKey: .articleUri)
            self.setValue(articleData.source.title, forKey: .company)
            self.setValue(articleData.body, forKey: .articleDescription)
        default:
            print("should check Struct")
        }
    }
}
