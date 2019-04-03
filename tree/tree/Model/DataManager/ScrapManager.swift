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
            NSEntityDescription.entity(forEntityName: "ArticleBase", in: managedContext) else {
                return
        }
        let newArticleBase = ArticleBase(entity: entity, insertInto: managedContext)
//        if let articleStruct = articleStruct as? Scrappable {
//            newArticleBase.setArticle(articleStruct,)
//        }
        switch type {
        case .search:
            guard
                let articleStruct = articleStruct as? SearchedArticleStruct,
                let searchDescription =
                NSEntityDescription.entity(
                    forEntityName: articleStruct.entityName,
                    in: managedContext
                ) else { return }
            let detailEntity = Search(entity: searchDescription, insertInto: managedContext)
            newArticleBase.setArticle(articleStruct, detailEntity)
        case .webExtracted:
            guard
                let articleStruct = articleStruct as? WebExtractedArticleStruct,
                let webExtractedDescription = NSEntityDescription.entity(
                    forEntityName: articleStruct.entityName,
                    in: managedContext
                ) else { return }
            let detailEntity = WebExtracted(entity: webExtractedDescription, insertInto: managedContext)
            newArticleBase.setArticle(articleStruct, detailEntity)
        case .web:
            guard
                let articleStruct = articleStruct as? WebViewArticleStruct,
                let webDescription = NSEntityDescription.entity(
                    forEntityName: articleStruct.entityName,
                    in: managedContext
                ) else { return }
            let detailEntity = Web(entity: webDescription, insertInto: managedContext)
            newArticleBase.setArticle(articleStruct, detailEntity)
        }
        
        do {
            try managedContext.save()
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            appDelegate.scrapViewController?.scrappedArticles = ScrapManager.fetchArticles()
//            appDelegate.scrapViewController?.setupScrapBadgeValue()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func fetchArticles() -> [ArticleBase] {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
        let sortDescriptor: NSSortDescriptor =
            NSSortDescriptor(
                key: #keyPath(ArticleBase.scrappedDate),
                ascending: false
        )
        request.sortDescriptors = [sortDescriptor]
        var result: [ArticleBase] = []
        result = fetchRequest(request)
        return result
    }
    
    static func fetchArticles(_ category: ArticleCategory) -> [ArticleBase] {
        var request: NSFetchRequest = ArticleBase.fetchRequest()
        var result: [ArticleBase] = []
        request.predicate =
            NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.articleType),
                category.rawValue
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
                #keyPath(ArticleBase.articleType),
                category.rawValue
            )
        } else {
            predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.articleType),
                category.rawValue
            )
        }
        return countArticleFetch(predicate)
    }
    
    typealias IsScrappedHandler = (Bool,ArticleBase?) -> Void
    static func articleIsScrapped(
        uri articleUri: String,
        completion: @escaping IsScrappedHandler
    ) -> Void {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
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
        let request: NSFetchRequest = ArticleBase.fetchRequest()
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
        let request: NSFetchRequest = NSFetchRequest<NSNumber>(entityName: "ArticleBase")
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
    
    static func removeArticle(_ article: ArticleBase) {
        managedContext.delete(article)
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func removeAllScrappedArticle() {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
        var results: [ArticleBase] = []
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
    
    static func fetchRequest(_ request: NSFetchRequest<ArticleBase>) -> [ArticleBase] {
        var result: [ArticleBase] = []
        do {
            result = try managedContext.fetch(request)
        } catch {
            print("Could not fetch. \(error)")
        }
        return result
    }
    
    static func markAllAsRead() {
        let batchUpdate = NSBatchUpdateRequest(entityName: "ArticleBase")
        batchUpdate.propertiesToUpdate = [#keyPath(ArticleBase.isRead): true]
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
//    func setValue(_ value: Any?, forKey property: ScrappedArticleProperty) {
//        self.setValue(value, forKeyPath: "\(property)")
//    }
    
//    func setCategory(_ category: ArticleCategory) {
//        self.setValue(category.stringValue, forKey: .category)
//    }
    
    func setupBaseProperty(_ type: ScrappedArticleType) {
        self.setValue(type.rawValue, forKey: "articleType")
        self.setValue(NSDate(), forKey: "scrappedDate")
        self.setValue(false, forKey: "isRead")
    }
    
    func setArticle(_ baseStruct: Scrappable, _ detailEntity: NSManagedObject) {
        switch baseStruct {
        case is WebViewArticleStruct:
            guard let webViewStruct = baseStruct as? WebViewArticleStruct else { return }
            self.setupBaseProperty(.web)
//            self.setValue(webViewStruct.title, forKey: .articleTitle)
//            self.setValue(webViewStruct.press, forKey: .articleAuthor)
//            self.setValue(webViewStruct.webData as NSData, forKey: .articleData)
//            self.setValue(webViewStruct.url, forKey: .articleURL)
//            self.setCategory(.live)
        case is WebExtractedArticleStruct:
            guard let webExtractedStruct = baseStruct as? WebExtractedArticleStruct else { return }
            self.setupBaseProperty(.webExtracted)
//            self.setValue(webExtractedStruct.title, forKey: .articleTitle)
//            self.setValue(webExtractedStruct.detail, forKey: .articleDescription)
//            self.setValue(webExtractedStruct.press, forKey: .articleAuthor)
//            self.setValue(webExtractedStruct.url, forKey: .articleURL)
//            self.setValue(webExtractedStruct.imageData, forKey: .articleData)
//            self.setCategory(.live)
        case is SearchedArticleStruct:
            self.setupBaseProperty(.search)
            guard
                let searhedArticleStruct = baseStruct as? SearchedArticleStruct,
                let articleData = searhedArticleStruct.articleData as? Article,
                let detailEntity = detailEntity as? Search
                else { return }
            if let authors = articleData.author,
                authors.count > 0 {
                self.setValue(authors.first?.name, forKey: "author")
            }
            self.setValue(
                ArticleCategory(containString: "\(articleData.categories.first)").rawValue,
                forKey: "category" )
            self.setValue(articleData.title, forKey: "title")
            detailEntity.setValue(articleData.date, forKey: "articleDate")
            detailEntity.setValue(articleData.uri, forKey: "webURI")
            detailEntity.setValue(articleData.body, forKey: "articleDescription")
            if let imageData: Data = searhedArticleStruct.imageData {
                detailEntity.imageData = imageData as NSData
            }
            self.setValue(detailEntity, forKey: "searched")
        default:
            fatalError("Check ArticleDataStruct Type")
        }
    }
}
